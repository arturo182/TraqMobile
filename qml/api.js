.pragma library

Qt.include("database.js")

function ajaxGet(url, callback)
{
    var req = new XMLHttpRequest();
    req.open("GET", url, true);
    req.onreadystatechange = function() { callback(req); };
    req.send();
}

function accountUrl(id)
{
    var url = "";

    var db = database();
    db.transaction(function(tx) {
        var result = tx.executeSql("SELECT url FROM accounts WHERE id = ?;", [id]);
        if(result.rows.length > 0)
            url = result.rows.item(0).url;
    });

    return url;
}

function loadProjects(model, id)
{
    var url = accountUrl(id);
    if(url == "")
        return;

    ajaxGet(url + "projects.json", function(req) {
        if(req.readyState == XMLHttpRequest.DONE) {
            var response = JSON.parse(req.responseText);

            for(var i in response) {
                var project = response[i];

                model.append(project);
            }
        }
    });
}

function loadTickets(model, id, slug)
{
    var url = accountUrl(id);
    if(url == "")
        return;

    ajaxGet(url + slug + "/tickets.json", function(req) {
        if(req.readyState == XMLHttpRequest.DONE) {
            var response = JSON.parse(req.responseText);

            for(var i in response) {
                var ticket = response[i];

                model.append(ticket);
            }
        }
    });
}
