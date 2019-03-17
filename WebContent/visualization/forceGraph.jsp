<!-- <svg width="1500" height="1000"></svg> -->
<script src="https://d3js.org/d3.v4.min.js"></script>
<script src="//d3js.org/d3-scale-chromatic.v0.3.min.js"></script>
<script>

var center = d3.select('#centerCol').node();

var width = center.getBoundingClientRect().width,
	height = width,
	padding = 10, 
	radius = 5; 
 
var svg = d3.select("#centerCol").append("svg")
	.attr("xmlns","http://www.w3.org/2000/svg")
	.attr("width", width+padding)
	.attr("height", height+padding);


var color = d3.scaleOrdinal()
	.domain(["1", "2", "3", "5"])
	.range(["#2E90C8", "#ea7156", "#F3BB30", "#68d659"]);



var simulation = d3.forceSimulation()
    .force("link", d3.forceLink())
    .force("charge", d3.forceManyBody(-00))
    .force("center", d3.forceCenter(width / 2, height / 2))
    .force("x", d3.forceX(width / 2).strength(0.1))
    .force("y", d3.forceY(height/2).strength(0.1));

d3.json("/gitforager/visualization/repo_people_data.jsp?id=${param.id}", function(error, graph) {
  if (error) throw error;
  
  var maxWeight = d3.max(graph.links, function(d) { return d.weight; });

//   var colorScale = d3.scaleSequential(d3.interpolateGreys)
//   	.domain([-100, maxWeight])

var colorScale = d3.scaleLinear()
        .domain([1, 10, maxWeight])
        .range(['#D4DFE7', '#2F75A4', '#20445B'])
        .interpolate(d3.interpolateHcl);
  
  var strokeScale = d3.scaleLinear()
  	.domain([1, maxWeight])
  	.range([.5,3])
  
  var link = svg.append("g")
  .attr("class", "links")
	.selectAll("line")
	.data(graph.links)
	.enter().append("line")
  	.style("stroke-width", function(d) { 
  		if (d.weight > 0){
  		return strokeScale(d.weight);}
  		else {return 1;}
  	})
  	.attr('marker-end','url(#arrowhead)')
  	.style("stroke", function(d){ 
  		if (d.weight > 0){
  		return colorScale(d.weight);}
  		else {return "#C3E7B2"}
  	});
  
  var node = svg.selectAll(".nodes")
	.data(graph.nodes)
	.enter().append("path")
  .attr("d", d3.symbol()
            .size(50)
        .type(function(d) { 
        if (d.group == 1 || d.group == 4) {return d3.symbols[1];} 
        if (d.group == 5) {return d3.symbols[3];}
        else {return d3.symbols[0];}
        }))
  .attr("fill", function(d) { return color(d.group); })
  .attr("stroke", "#8B9DA7")
  .attr("stroke-width", ".5px")
  .on("dblclick", function(d) { if (d.group == 1) {
                                   window.open("/gitforager/repository/repository.jsp?id="+d.url.substring(1),"_self");
                                } else if (d.group == 2) {
                                   window.open("/gitforager/user/user.jsp?id="+d.url,"_self");
                                } else if (d.group == 3) { // TODO this one still needs work! (Need to handle non-id-holding committers.)
                                    window.open("/gitforager/user/user.jsp?id="+d.url,"_self");                                        
                                } else if (d.group == 5) {
                                    window.open("/gitforager/organization/organization.jsp?id="+d.url.substring(1),"_self");                                        
                                }
                              })
  .call(d3.drag()
      .on("start", dragstarted)
      .on("drag", dragged)
      .on("end", dragended));


  node.append("title")
      .text(function(d) { return d.name; });

  simulation
      .nodes(graph.nodes)
      .on("tick", ticked);

  simulation.force("link")
      .links(graph.links);

  
  function ticked() {
    // added bouding box
    node.attr("transform", function(d) {return  "translate(" + ( Math.max(radius, Math.min(width - radius, d.x))) + "," + (Math.max(radius, Math.min(height - radius, d.y))) + ")" ;});
    
    link
    .attr("x1", function(d) { return ( Math.max(radius, Math.min(width - radius, d.source.x))) ; })
    .attr("y1", function(d) { return (Math.max(radius, Math.min(height - radius, d.source.y))) ; })
    .attr("x2", function(d) { return ( Math.max(radius, Math.min(width - radius, d.target.x)))  ; })
    .attr("y2", function(d) { return (Math.max(radius, Math.min(height - radius, d.target.y))) ; });
  }
});

function dragstarted(d) {
  if (!d3.event.active) simulation.alphaTarget(0.3).restart();
  d.fx = d.x;
  d.fy = d.y;
}

function dragged(d) {
  d.fx = d3.event.x;
  d.fy = d3.event.y;
}

function dragended(d) {
  if (!d3.event.active) simulation.alphaTarget(0);
  d.fx = null;
  d.fy = null;
}

</script>
