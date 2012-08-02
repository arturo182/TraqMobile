.pragma library

function loadProjects(model, url)
{
    var doc = new XMLHttpRequest();
    doc.open("GET", url + "projects.json", true);
    doc.onreadystatechange = function() {
        if(doc.readyState == XMLHttpRequest.DONE) {
            var response = JSON.parse(doc.responseText);

            for(var i in response) {
                var project = response[i];

                model.append(project);
            }
        }
    }
    doc.send();
}
