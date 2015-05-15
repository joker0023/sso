<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
  <head>
  	<meta charset="utf-8">
    <title>500</title>
    <link rel="shortcut icon" href="${pageContext.request.contextPath }/favicon.ico">
    <style type="text/css">
    	body {
    		background: linear-gradient(to right, #EFF,#FFF,#EEF);
    	}
    	.container {
    	
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
    	#mycanvas {
    	}
    </style>
  </head>
  <body>
  	<div class="container">
  		<div class="description">
  			<canvas id="mycanvas" width="430" height="300">
  				服务器出错了!
  			</canvas>
  		</div>
 	</div>
 	
 	<script type="text/javascript">
 		var canvas = document.getElementById("mycanvas");
 		var context = canvas.getContext("2d");
 		var tearArr = [120, 123, 127, 130, 127, 123, 120];
 		var eyeArr = [90, 85, 80, 75, 80, 85, 90];
 		
 		context.translate(0,50);
 		
		drawFace(0);
		drawText();
		setInterval(function(){
 			faceMove();
 	 	}, 1500);
 		
 		function faceMove(){
 			var index = 0;
 	 		var intervalId = setInterval(function(){
 	 			context.clearRect(0, -50, 500, 400);
 	 			drawFace(index % tearArr.length);
 	 			drawText();
 	 			index++;
 	 			if(index >= tearArr.length * 2){
 	 				clearInterval(intervalId);
 	 			}
 	 		}, 30);
 		}
 		
 		function drawText(index){
 			context.font = "60px 宋体";
 	 		context.fillStyle = "#f33";
 	 		context.textAlign = "end";
 	 		context.textBaseline = "bottom";
 	 		
 	 		context.save();
 	 		context.translate(220, 10);
 	 		context.rotate(-1);
 	 		
 	 		context.fillText("出", 0, 0);
 	 		context.restore();
 	 		
 	 		context.textAlign = "start";
 	 		
 	 		context.fillText("错", 220, 90);
 	 		
 	 		context.fillText("了!", 200, 170);
 		}
 		function drawFace(index){
 			drawBaseFace(index);
 			
 			//眼泪
 	 		context.fillStyle = "#FFF";
 	 		context.beginPath();
 	 		context.moveTo(160, tearArr[index]);
 	 		context.bezierCurveTo(140, tearArr[index] + 50, 180, tearArr[index] + 50, 160, tearArr[index]);
 	 		context.closePath();
 	 		context.fill();
 	 		
 	 		//绷带
 	 		context.fillStyle = "#FFF";
 	 		context.strokeStyle = "#CCC";
 	 		context.beginPath();
 	 		context.moveTo(125, 20);
 	 		context.lineTo(115, 35);
 	 		context.lineTo(145, 60);
 	 		context.lineTo(155, 45);
 	 		context.closePath();
 	 		context.fill();
 	 		context.stroke();
 	 		
 	 		context.beginPath();
 	 		context.moveTo(145, 20);
 	 		context.lineTo(155, 35);
 	 		context.lineTo(125, 60);
 	 		context.lineTo(115, 45);
 	 		context.closePath();
 	 		context.fill();
 	 		context.stroke();
 		}
 		function drawBaseFace(index){
 			var grd = context.createRadialGradient(100, 100, 20, 100, 100, 90);
 	 		grd.addColorStop(0, "#999");
 	 		grd.addColorStop(1, "#333");
 	 		context.fillStyle = grd;
 	 		
 	 		//头
 	 		context.beginPath();
 	 		context.arc(100, 100, 90, 0, Math.PI*2, true);
 	 		context.fill();
 	 		
 	 		//眼睛
 	 		context.fillStyle = "#FFF";
 	 		context.beginPath();
 	 		context.arc(60, 80, 45, 0, Math.PI*2, true);
 	 		context.fill();
 	 		context.beginPath();
 	 		context.arc(140, 80, 45, 0, Math.PI*2, true);
 	 		context.fill();
 	 		
 	 		//眼珠
 	 		context.fillStyle = "#333";
 	 		context.beginPath();
 	 		context.arc(60, 75, 15, 0, Math.PI*2, true);
 	 		context.fill();
 	 		context.beginPath();
 	 		context.arc(140, 75, 15, 0, Math.PI*2, true);
 	 		context.fill();
 	 		
 	 		context.fillStyle = "#FFF";
 	 		//context.fillRect(45, 60, 110, 13);
 	 		context.fillRect(45, 150 - eyeArr[index] - 15, 30, 15);
 	 		context.fillRect(125, 150 - eyeArr[index] - 15, 30, 15);
 	 		
 	 		context.fillRect(45, eyeArr[index], 30, 15);
 	 		context.fillRect(125, eyeArr[index], 30, 15);
 	 		
 	 		//头顶
 	 		context.fillStyle = "#333";
 	 		context.beginPath();
 	 		context.moveTo(40, 38);
 	 		context.lineTo(35, 25);
 	 		context.lineTo(28, 20);
 	 		context.lineTo(40, 17);
 	 		context.closePath();
 	 		context.fill();
 	 		
 	 		context.beginPath();
 	 		context.moveTo(90, 14);
 	 		context.lineTo(93, 5);
 	 		context.lineTo(98, 2);
 	 		context.lineTo(105, 0)
 	 		context.lineTo(100, 3)
 	 		context.lineTo(97, 9)
 	 		context.closePath();
 	 		context.fill();
 	 		
 	 		context.beginPath();
 	 		context.moveTo(148, 25);
 	 		context.lineTo(160, 15);
 	 		context.lineTo(170, 20);
 	 		context.closePath();
 	 		context.fill();
 		}
 	</script>
  </body>
</html>

