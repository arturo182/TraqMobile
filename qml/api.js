.pragma library

Qt.include("database.js")

var pageStack = null;

function ajaxGet(url, callback)
{
    var req = new XMLHttpRequest();
    req.open("GET", url);
    req.onreadystatechange = function() {
        callback(req);
        pageStack.busy = false;
    };
    req.send();
}

function ajaxFillModel(url, model)
{
    ajaxGet(url, function(req) {
        if(req.readyState == XMLHttpRequest.DONE) {
            var response = JSON.parse(req.responseText);

            for(var i in response) {
                model.append(response[i]);
            }
        }
    });
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

    ajaxFillModel(url + "projects.json", model);
}

function loadTickets(model, id, slug)
{
    var url = accountUrl(id);
    if(url == "")
        return;

    ajaxFillModel(url + slug + "/tickets.json", model);
}
