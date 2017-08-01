Shiny.addCustomMessageHandler("jsondata4",
  function(message){
   // var data = message;



//Dimensions
   // var dataArray = [23, 13, 21, 14, 37, 15, 18, 34, 30];
var margin = {top: 40, right: 20, bottom: 30, left: 70},
    width = 460 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom;

// Ranges
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
    .tickFormat(formatPercent);

var svg = d3.select("#box1").append("svg")
.attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
  .append("g")
    .attr("transform", 
          "translate(" + margin.left + "," + margin.top + ")");
          //

var data=[{"gender":"female","count":1380},{"gender":"male","count":2915},{"gender":"Not Specified","count":1536}];

x.domain(data.map(function(d) { return d.gender; }));
  y.domain([0, d3.max(data, function(d) { return d.count; })]);

svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + height + ")")
      .call(xAxis);

  svg.append("g")
      .attr("class", "y axis")
      .call(yAxis)
    .append("text")
      .attr("transform", "rotate(-90)")
      .attr("y", 6)
      .attr("dy", ".71em")
      .style("text-anchor", "end")
      .text("Frequency");

svg.selectAll(".bar")
    .data(data)
    .enter().append("rect")
          .attr("class", "bar")
          .attr("x", function(d) { return x(d.gender); })
        .attr("width", x.rangeBand())
        .attr("y", function(d) { return y(d.count); })
        .attr("height", function(d) { return height - y(d.count); });

  
  function type(d) {
  d.count = +d.count;
  return d;
}
})