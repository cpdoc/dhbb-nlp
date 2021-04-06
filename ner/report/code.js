//function load(){
//    document.getElementById('output').innerHTML = "Oh my God!";
//}

// precisamos de uma variável para armazenar a string
let df;
d3.json("test.json").then(data => df = JSON.stringify(data));

function load(df){
  var json = df.replace(/\n/g, " ") ;
  window.data = JSON.parse(json) ;
  var tab = data.table;
  var tipos = data.header;
  saida = '<tr><th>' + "Linhas: NLU e Colunas: WKS" + '</th> </tr>'
  saida += '<div><table id="tabela1"><tr><th>&nbsp;</th>';
  for (k = 0; k < tipos.length; k++){
      saida += '<th>' + tipos[k] + '</th>';
  }
  saida += '</tr>'
  for (i = 0; i < tab.length; i++) {
      saida += '<tr><th>' + tipos[i] + '</th>';
      for (j = 0; j < (tab[i]).length; j++){
          saida += '<td><span onclick="my(id ='+ (j + i*(tab[i]).length).toString() + ')">' + (tab[i][j]).toString() + '</span></td>';
      }
      saida += '</tr>';
      }
  saida += '</table></div>';
  document.getElementById('output').innerHTML = saida;
}

function my(id) {
  var cont = data.content
  var menlist = cont[id]
  saida2 = saida
  saida2 += '<table id="tabela2">'
  saida2 += '<tr><th>' + "NLU = " + ((menlist[0]).comp)[0] + " e " + "WKS = " + ((menlist[0]).comp)[1]+ '</th> </tr>'
  for (i = 0; i < menlist.length; i++){
      saida2 += '<tr><th>' + (menlist[i]).mention +'</th> <td>' 
                           + ((menlist[i]).doc).substring(0 ,((menlist[i]).doc).length - 4) + '</td> <td style="color:blue">' 
                           + ((menlist[i]).context).substring(0, ((menlist[i]).rangeInSent)[0]) + '<b>' 
                           + ((menlist[i]).context).substring(((menlist[i]).rangeInSent)[0], ((menlist[i]).rangeInSent)[1]) + '</b>' 
                           + ((menlist[i]).context).substring(((menlist[i]).rangeInSent)[1]) + '</td></tr>'
  }
  saida2 += '<table>'
  document.getElementById('output').innerHTML = saida2;
}

setTimeout(() => {
  // intervalo para renderizar os elementos do DOM
  // e para ler o arquivo (em milissegundos)
  console.log(df); 
  load(df); 

}, 225);
