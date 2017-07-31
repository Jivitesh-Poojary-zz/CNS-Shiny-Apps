Shiny.addCustomMessageHandler("sankey_d3plus",
  function(message){
    var url = message;
  var units = "Widgets";
var margin = {top: 40, right: 20, bottom: 30, left: 70},
    width = 460 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom;


// append the svg canvas to the page


var svg = d3.select("#sankeyd3plus").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
  .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  var nodes = [
    {"id": "alpha"},
    {"id": "beta"},
    {"id": "gamma"}
  ];
  var edges = [
    {"strength": 2, "source": 0, "target": 2},
    {"strength": 1, "source": 1, "target": 2},
    {"strength": 1, "source": 2, "target": 0},
    {"strength": 3, "source": 2, "target": 1}
  ];

  var visualization = d3plus.viz()
    .container("#sankeyd3plus")
    .edges({
      "strength": "strength",
      "value": edges
    })
    .focus({
      "tooltip": false,
      "value": "gamma"
    })
    .id("id")
    .nodes(nodes)
    .size(100)
    //.size(10)
    .type("sankey")
    .draw();
  })