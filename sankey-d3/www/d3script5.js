Shiny.addCustomMessageHandler("jsondata5",
  function(message){
   // var data = message;
var margin = {top: 40, right: 20, bottom: 30, left: 70},
    width = 460 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom;

//var data=[{"Employee":"John Doe","Salary":58},{"Employee":"Jane Doe"//,"Salary":81},{"Employee":"Mary Jane","Salary":39},{"Employee":"Debasis //Das","Salary":80},{"Employee":"Nishant Singh","Salary":99}];

//var color = d3.scale.category10();
var c10 = d3.scale.category10();

var data=[{"Education":"high school","count":231},{"Education":"undergraduate","count":948},{"Education":"graduate","count":2419},{"Education":"PhD","count":717},{"Education":"Unknown","count":1378}];

var x = d3.scale.ordinal()
    .rangeRoundBands([0, width], .1);

var y = d3.scale.linear()
    .range([height, 0]);

var xAxis = d3.svg.axis()
    .scale(x)
    .orient("bottom");

var yAxis = d3.svg.axis()
    .scale(y)
    .orient("left")
    .ticks(10, "");


var svg = d3.select("#box5").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
  .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

//svg.call(tip);



x.domain(data.map(function(d) { return d.Education; }));
y.domain([0, d3.max(data, function(d) { return d.count; })]);

svg.append("g")
  .attr("class", "x axis")
  .attr("transform", "translate(0," + height + ")")
  .call(xAxis);

svg.append("g")
  .attr("class", "y axis")
  .call(yAxis)
.append("text")
  //.attr("transform", "rotate(-90)")
  .attr("y", -28)
  .attr("dy", ".71em")
  .style("text-anchor", "end")
  .text("count");

svg.selectAll("rect")
  .data(data)
.enter().append("rect")
  .attr("class", "bar")
  .attr("x", function(d) { return x(d.Education); })
  .attr("width", x.rangeBand())
 // .style("background-color", function(d, i) {
  //  return color(i);})
  .attr("y", function(d) { return y(d.count); })
  .attr("fill", function(d,i) { return c10(i); } )
  .attr("height", function(d) { return height - y(d.count); });
 // .on('mouseover', tip.show)
 // .on('mouseout', tip.hide);


function type(d) {
  d.count = +d.count;
  return d;
}

})