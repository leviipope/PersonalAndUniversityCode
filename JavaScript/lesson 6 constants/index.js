// cons = a variable that cant be changed

const PI = 3.14159; // constants have uppercase names if boolean or numbers
let radius;
let circumference;

document.getElementById("mySubmit").onclick = function(){
    radius =  document.getElementById("myText").value;
    radius = Number(radius);
    circumference = 2 * PI * radius;
    document.getElementById("myH3").textContent = circumference + "cm";
}