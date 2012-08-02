function database()
{
    return openDatabaseSync("traqmobile", "1.0", "database", 100000);
}

function init()
{
    var db = database();

    db.transaction(function(tx) {
        tx.executeSql("CREATE TABLE IF NOT EXISTS settings(key TEXT UNIQUE, value TEXT);");
        tx.executeSql("CREATE TABLE IF NOT EXISTS accounts(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, url TEXT, private_key TEXT);");

        //check for default settings
        if(!setting("theme"))
            setSetting("theme", "default");
    });
}

function setSetting(key, value)
{
    var db = database();
    db.transaction(function(tx) {
        tx.executeSql("INSERT OR REPLACE INTO settings VALUES (?, ?);", [key, value]);
    });
}

function setting(key)
{
    var db = database();
    var res = 0;

    db.transaction(function(tx) {
        var result = tx.executeSql("SELECT value FROM settings WHERE key = ?;", [key]);
        if(result.rows.length > 0)
            res = result.rows.item(0).value;
    });

    return res;
}

function fillModel(sql, model)
{
    var db = database();

    db.transaction(function(tx) {
        var result = tx.executeSql(sql);
        if(result.rows.length > 0) {
            for(var i = 0; i < result.rows.length; ++i) {
                model.append(result.rows.item(i));
            }
        }
    });
}

function loadAccounts(model)
{
    fillModel("SELECT * FROM accounts ORDER BY name ASC;", model);
}

function addAccount(name, url, api_key)
{
    var db = database();
    if(url.substr(-1) != "/")
        url += "/";

    db.transaction(function(tx) {
        tx.executeSql("INSERT INTO accounts(name, url, private_key) VALUES (?, ?, ?);", [name, url, api_key]);
    });
}

function modifyAccount(id, name, url, api_key)
{
    var db = database();
    if(url.substr(-1) != "/")
        url += "/";

    db.transaction(function(tx) {
        tx.executeSql("UPDATE accounts SET name = ?, url = ?, private_key = ? WHERE id = ?;", [name, url, api_key, id]);
    });
}

function deleteAccount(id)
{
    var db = database();
    db.transaction(function(tx) {
        tx.executeSql("DELETE FROM accounts WHERE id = ?;", [id]);
    });
}
