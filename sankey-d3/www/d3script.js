Shiny.addCustomMessageHandler("jsondata",
  function(message){
    var data = message;
    var c10 = d3.scale.category10();
var w = 500;
			var h = 200;
			var barPadding = 1; 
    //Width and height

    var dataset = [1380,2915,1536];
    var label =["female","male","undefined"];
//var dataset = [ 5, 10, 13, 19, 21, 25, 22, 18, 15, 13,
    //            11, 12, 15, 20, 18, 17, 16, 18, 23, 25 ];
var svg = d3.select("#box1").append("svg")
          //.attr("height","100%")
         // .attr("width","100%");
            .attr("width", w)
            .attr("height", h);

//svg.selectAll("rect")
svg.selectAll("rect")
    .data(dataset)
    .enter().append("rect")
      .attr("class", "bar")
      .attr("x", function(d, i) {return i * (w / dataset.length);})
			   .attr("y", function(d) {return h - ((d / 100)*5);})
			   .attr("width", w / dataset.length - barPadding)
			    .attr("fill", function(d,i) { return c10(i); } )
			   .attr("height", function(d) {return (d /100)*6 ;});

          //.attr("height", function(d) { return height - y(d); });
         // .attr("y", function(d, i) {return 400 - (d * 10)});

svg.selectAll("text")
			   .data(dataset)
			   .enter()
			   .append("text")
			   .text(function(d) {return d;})
			   .attr("x", function(d, i) {return i * (w / dataset.length) + 45;})
			   //.attr("y", function(d) {return h - ((d /100)*3) + 15;})
			   .attr("y", 15)
			   .attr("font-family", "sans-serif")
			   .attr("font-size", "11px")
			   .attr("fill", "black");

svg.selectAll(".bartext")
.data(label)
.enter()
.append("text")
.attr("class", "bartext")
.attr("text-anchor", "middle")
.attr("fill", "white")
			   .text(function(d) {return d;})
            .attr("y", 155)
            .attr("x", function(d, i) {return (i * w/3) + 75;})
            //.attr("dy", ".35em") //vertical align middle
            .attr("font-family", "sans-serif")
			   .attr("font-size", "12px");

  });