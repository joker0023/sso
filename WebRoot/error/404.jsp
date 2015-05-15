<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
  <head>
  	<meta charset="utf-8">
    <title>404</title>
    <link rel="shortcut icon" href="${pageContext.request.contextPath }/favicon.ico">
    <style type="text/css">
    	body {
    		background: linear-gradient(to right, #EFF,#FFF,#EEF);
    	}
    	.description {
    		text-align: center;
    		font-weight: bold;
    		font-size: 50px;
    		color: red;
    		margin-top: 100px;
    		width: 80%;
    		margin: 100px auto;
    		padding: 50px;
    		text-shadow: 15px 15px 4px #3399FF;
    	}
    	#mycanvas{
    	}
    </style>
  </head>
  <body>
  	<div class="container">
  		<div class="description">
  			<canvas id="mycanvas" width="500" height="300">
  				404:您查看的页面已经不存在了!
  			</canvas>
  		</div>
 	</div>
 	
 	<script type="text/javascript">
 		var canvas = document.getElementById("mycanvas");
 		var context = canvas.getContext("2d");
 		
 		draw(1);
 		move();
 		
 		function move(){
 			var index = 0;
 	 		var intervalId = setInterval(function(){
 	 			context.clearRect(0, 0, 450, 300);
 	 			draw(index);
 	 			index = (index + 1) % 2;
 	 		}, 800);
 		}
 		function draw(index){
 			var grd = context.createRadialGradient(150, 150, 20, 150, 150, 100);
 	 		grd.addColorStop(0, "#66CCFF");
 	 		grd.addColorStop(1, "#3399FF");
 	 		context.fillStyle = grd;
 	 		
 	 		//头
 	 		context.beginPath();
 	 		context.arc(150, 150, 100, 0, Math.PI*2, true);
 	 		context.fill();
 	 		
 	 		//眼睛
 	 		context.fillStyle = "#666";
 	 		context.strokeStyle = "#333";
 	 		context.beginPath();
 	 		context.arc(90, 70, 50, 0 + 0.3, 1.8, false);
 	 		context.stroke();
 	 		context.beginPath();
 	 		context.arc(210, 70, 50, Math.PI - 0.3, 1.34, true);
 	 		context.stroke();
 	 		
 	 		if(index % 2 == 1){
 	 			context.fillStyle = "#333";
 	 	 		context.fillRect(75, 130, 50, 5);
 	 	 		context.fillRect(165, 130, 50, 5);
 	 	 		
 	 			context.beginPath();
 	 	 		context.arc(90, 135, 10, 0, Math.PI, false);
 	 	 		context.fill();
 	 	 		context.arc(180, 135, 10, 0, Math.PI, false);
 	 	 		context.fill();
 	 		}else{
 	 			context.fillStyle = "#333";
 	 	 		context.fillRect(65, 130, 80, 5);
 	 	 		context.fillRect(155, 130, 80, 5);
 	 	 		
 	 			context.fillStyle = "#FFF";
 	 	 		context.beginPath();
 	 	 		context.arc(105, 120, 40, 0.4, 2.75, false);
 	 	 		context.stroke();
 	 	 		context.fill();
 	 	 		context.beginPath();
 	 	 		context.arc(195, 120, 40, 0.4, 2.75, false);
 	 	 		context.stroke();
 	 	 		context.fill();
 	 	 		
 	 	 		context.fillStyle = "#333";
 	 	 		context.beginPath();
 	 	 		context.arc(120, 135, 10, 0, Math.PI, false);
 	 	 		context.fill();
 	 	 		context.arc(210, 135, 10, 0, Math.PI, false);
 	 	 		context.fill();
 	 		}
 	 		
 	 		//汗
 	 		context.fillStyle = "#FFF";
 	 		context.beginPath();
 	 		context.moveTo(225, 90);
 	 		context.bezierCurveTo(190, 160, 260, 160, 225, 90);
 	 		context.closePath();
 	 		context.fill();
 	 		
 	 		
 	 		var startLeft = 90;
 	 		var startTop = 70;
 	 		//绷带
 	 		context.fillStyle = "#FFF";
 	 		context.strokeStyle = "#CCC";
 	 		context.beginPath();
 	 		context.moveTo(startLeft, startTop);
 	 		context.lineTo(startLeft - 10, startTop + 15);
 	 		context.lineTo(startLeft + 20, startTop + 40);
 	 		context.lineTo(startLeft + 30, startTop + 25);
 	 		context.closePath();
 	 		context.fill();
 	 		context.stroke();
 	 		
 	 		context.beginPath();
 	 		context.moveTo(startLeft + 20, startTop);
 	 		context.lineTo(startLeft + 30, startTop + 15);
 	 		context.lineTo(startLeft, startTop + 40);
 	 		context.lineTo(startLeft - 10, startTop + 25);
 	 		context.closePath();
 	 		context.fill();
 	 		context.stroke();
 	 		
 	 		//文字
 	 		context.fillStyle= "#3399FF";
 	 		context.textAlign = "start";
 	 		context.textBaseline = "top";
 	 		var textLeft = 250, textTop = 50;
 	 		
 	 		context.fillRect(textLeft, textTop, 16, 50);
 	 		context.fillRect(textLeft + 10, textTop + 40, 50, 16);
 	 		context.fillRect(textLeft + 40, textTop, 16, 70);
 	 		
 	 		context.fillRect(textLeft + 140, textTop, 16, 50);
 	 		context.fillRect(textLeft + 150, textTop + 40, 50, 16);
 	 		context.fillRect(textLeft + 180, textTop, 16, 70);
 	 		
 	 		context.fillRect(textLeft + 210, textTop, 16, 50);
 	 		context.fillRect(textLeft + 210, textTop + 60, 16, 16);
 	 		
 	 		context.font = "45px 'Monotype Corsiva'";
 	 		context.fillText("NOT FOUND", textLeft, 200);
 	 		
 	 		context.font = "80px 宋体";
 	 		context.fillText("囧", textLeft + 60, textTop - 5);
 		}
 	</script>
  </body>
</html>

