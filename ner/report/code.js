
function load(){
    document.getElementById('examples').innerHTML = "Oh my God!";
    create_table();
}

function my(obj) {
    document.getElementById('examples').innerHTML = '<p>' + obj.id +  '</p><ul><li>...<b>word</b>... </li><li>...<b>word</b>...</li></ul>';
}

function create_table() {
    // ler o json
    document.getElementById('table').innerHTML = '<table style="border: 1px solid black;"> <tr> <td><span id="cell11" onclick="my(this)">12</span></td><td>12</td> </tr><tr> <td>12</td><td>12</td> </tr> </table>';
}


