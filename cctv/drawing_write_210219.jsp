<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>


<% request.setCharacterEncoding("UTF-8"); %>

<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>X-AIVA-KB</title>
		<jsp:include page="/include/import"  flush="false" />
		
		<!-- Import JS	-->
		<!-- <script src="<c:url value="/js/color-hash.js" />"></script>
		<script src="<c:url value="/js/fabric.min.js" />"></script> -->
		
		<style>
			#drawingWrite {}
			#drawingWrite .input_wrap {     border-top: 2px solid #2b2b2b; padding: 20px 0; margin-top: 30px;  }
			#drawingWrite .input_wrap .input_box {   margin-bottom: 30px;  }
			#drawingWrite .input_cont  { width: 800px;   }
			#drawingWrite .input_label { width: 120px; padding-left: 30px; }
			
			#drawingWrite canvas { /* border: 1px solid #d9d9d9; */ display: block; }
			#drawingWrite .canvas-container { width: 800px !important; border: 1px solid #d9d9d9; }
			#drawingWrite .canvas_wrap { display: flex; position: relative; -ms-display: flexbox; display: flex; flex-wrap: wrap; -webkit-justify-content: center; justify-content: center; -webkit-align-items: center; align-items: center; }
			#drawingWrite .canvas_wrap.fs { justify-content: flex-start; }
			#drawingWrite .canvas_wrap.crop { display: none; }
			#drawingWrite .controlbar { width: 360px; height: 30px; margin: 3px 0; top: -40px; left: 590px;}
			#drawingWrite .btn_move,
			#drawingWrite .btn_zoom,
			#drawingWrite .btn_load { padding: 3px 8px; background-color: #fff; color: #999; border: 1px solid #d9d9d9; border-radius: 3px; margin-right: 3px; }
			#drawingWrite .crop_img { border: 1px solid #d9d9d9; }
			#drawingWrite .coord { width: 780px; margin-top: 15px; padding: 10px; font-size: 9px; border: 1px solid #d9d9d9; background-color: #f8f8f8; color: #999; }
			
			#drawingWrite .upload_hidden { position: absolute; width: 1px; height: 1px; padding: 0; margin: -1px; overflow: hidden; clip: rect(0,0,0,0); border: 0; }
			#drawingWrite .input_box.file .input_cont { width: 740px; background-color: #fff; border: 1px solid #d9d9d9; }
			#drawingWrite .input_box.file label { display: inline-block; padding: 9px; margin-left: 4px; color: #fff; font-size: inherit; line-height: normal; vertical-align: middle; background-color: #60584c; cursor: pointer; border: 1px solid #60584c; }
			#drawingWrite .input_box.file label:hover { background-color: #4a443a; }
		</style>
		
	</head>
	
	<body>
		<jsp:include page="/include/header"  flush="false" />
		
		<div class="container" id="drawingWrite">
			<div class="wrapper">
				<div class="contents">
					<h1 class="page_title">도면 등록</h1>
<!-- 					<h2 class="page_desc">영업점 등록 페이지 입니다</h2> -->
					
					
					<div class="input_wrap">
					
						<div class="input_box flex fs">
							<span class="input_label">도면 이름</span>
							<input class="input_cont" type="text" name="title" placeholder="" data-label="도면 이름" required />
						</div>
						<div class="input_box flex fs">
							<span class="input_label">도면 설명</span>
							<textarea class="input_cont" type="text" name="contents" data-label="도면 설명" placeholder=""></textarea>
						</div>
						<div class="input_box flex fs file">
							<span class="input_label">도면 업로드</span>
<!-- 							<input id='image_file' class="input_cont" type='file'name='image_file' data-label="도면 업로드" required /> -->
							<input class="input_cont" type="text" value="" disabled="disabled" />
							<label for="image_file">업로드</label>
							<input id='image_file' class="upload_hidden" type='file' name='image_file' data-label="도면 업로드" required />
						</div>						
						
						<div class="canvas_wrap orig fs">
							<span class="input_label">도면 영역 선택</span>
<!-- 							<button id="image_load" class="btn_load" data-labael="도면 불러오기">불러오기</button> -->
							<canvas id="canvas"></canvas>
							<div class="controlbar flex">
								<button class="btn_move left">LEFT</button>
								<button class="btn_move right">RIGHT</button>
								<button class="btn_move up">UP</button>
								<button class="btn_move down">DOWN</button>
								<button class="btn_zoom in">+</button>
								<button class="btn_zoom out">-</button>
								<button class="btn_zoom reset">RESET</button>
							</div>
						</div>
						<div class="canvas_wrap crop fs">
							<span class="input_label">미리보기</span>
							<canvas id="crop_img" class="crop_img"></canvas>
<!-- 							<span class="input_label">좌표 정보</span> -->
<!-- 				            <div class="coord"> -->
<!-- 				                <div class="orig"><b>Original Image Size: </b><br><span></span></div><br> -->
<!-- 				                <div class="orig_coord"><b>Original Image Coordinate: </b><br><span></span></div><br> -->
<!-- 				                <div class="crop"><b>Crop Image Coordinate(rescale): </b><br><span></span></div> -->
<!-- 				            </div>  -->
						</div>
						<div class="canvas_wrap crop fs">
							<span class="input_label">좌표 정보</span>
				            <div class="coord">
				                <div class="orig"><b>원본 이미지 크기 : </b><br><span></span></div><br>
				                <div class="orig_coord"><b>원본 이미지 좌표 정보 : </b><br><span></span></div><br>
				                <div class="crop"><b>크롭 이미지 좌표 정보(rescale 된 값): </b><br><span></span></div>
				            </div> 
						</div>						
					</div>
					
					<div class="btn_wrap">
<%-- 						<div class="btn_wh btn_cancel"><a href="<c:url value="/office/list"/>">취소</a></div> --%>
<%-- 						<div class="btn_br btn_submit"><a href="<c:url value="/office/write"/>">등록</a></div> --%>
						<div class="btn_wh btn_cancel"><a href="<c:url value="#"/>">취소</a></div>
						<div class="btn_br btn_submit"><a href="<c:url value="#"/>">등록</a></div>
					</div>
					
				</div>
			</div>
		</div>
		<!-- <jsp:include page="/include/footer"  flush="false" /> -->
		
		<script>
		
			$(function(){
				var that = drawingWrite;
				
				that.data.canvas = new fabric.Canvas("canvas",{
	                width: 800,
	                height: 600,
	                selection : false,
	                uniScaleTransform : true,					
				});
				
				drawingWrite.init();
			});
			
			var drawingWrite = {
				pt: $("#drawingWrite"),
				data : {
	                clsImage : null,
	                iCropLeft : null,
	                iCropTop : null,
	                iCropWidth : null,
	                iCropHeight : null,
	                iImageWidth : null,
	                iImageHeight : null,
	                
	                // initial canvas and canvas var
	                canvas : null,
	                canvasObj : {
	                    origX : 0, 
	                    origY : 0, 
	                    isDown : false, // default : false
	                    freeDrawing : false, // default : false
	                    currDataNum : 1,
	                    datasetId : null,
//	 						isRectActive : true,
	                    state : false,
	                    isModified : 0,
	                },
	                rectObj : {},
	                scaleFactor : {origWidth:0, origHeight:0, ratio:1, minBboxSize:0},
	                meta : {},
	                colorHash : null,	                
				},
				init: function(){
					var that = this;
					that.data.colorHash = new ColorHash();
					that.pk = that.pt.attr("id");
					that.evtOnceInit();
					that.listener();
				},
                evtOnceInit : function(){
                    this.downEvt();
                    this.moveEvt();
                    this.upEvt();
                    this.wheelEvt();
                    this.objMovingEvt();
                    this.objModifiedEvt();
                    this.objScalingEvt();
//                     this.keydownEvt();
                },		
                downEvt : function(){
                    var  that = this;
                    var canvas = that.data.canvas;
                    
                    that.data.canvas.on('mouse:down',function(o){
                        var uuid = that.data.uuid;
                        

                        that.data.canvasObj.isDown = true;
                        if($("input#image_file").val() != "" && that.data.canvas.imgInfo != undefined){
                            //that.data.canvasObj.isDown = true;
                            that.data.canvasObj.freeDrawing = true;
                        }

                        var canv = that.data.canvas.getObjects();
                        for(var i=0; i<canv.length; i++){
                            if(canv[i]["uuid"] == uuid){
                                that.data.canvasObj.freeDrawing = false;
                                that.data.canvas.setActiveObject(canv[i]);
                                return;
                            }
                        }

                        if(that.data.canvasObj.freeDrawing == true && uuid !=""){
                            var pointer = canvas.getPointer(o.e);
                            
                            that.data.canvasObj.origX = pointer.x;
                            that.data.canvasObj.origY = pointer.y;
                            
                            if(that.data.canvasObj.isDown){
                                var temp = {
                                    uuid : uuid,
                                    left: that.data.canvasObj.origX,
                                    top: that.data.canvasObj.origY,
                                    width: pointer.x - that.data.canvasObj.origX,
                                    height : pointer.y - that.data.canvasObj.origY,
                                };
                                
                                var rectObj = that.getRectObject(temp, uuid);
                                //that.data.rectObj = rectObj;
                                // canvas.add(that.data.rectObj);
                                that.initRect(rectObj, uuid);
                            }

                        }

                        
                    });                    
                },

                moveEvt : function(){
                    var  that = this;
                    var data = that.data;
                    var canvas = that.data.canvas;
                    
                    canvas.on('mouse:move', function(evt) {
/*                        if(!that.data.canvasObj.isDown) return;
                        
                        var pointer = canvas.getPointer(o.e);
                        if(that.data.canvasObj.origX > pointer.x){
                            that.data.rectObj.set({ left: Math.abs(pointer.x) });
                        }
                        if(that.data.canvasObj.origY > pointer.y){
                            that.data.rectObj.set({ top: Math.abs(pointer.y) });
                        }

                        that.data.rectObj.set({ width: Math.abs(that.data.canvasObj.origX - pointer.x) });
                        that.data.rectObj.set({ height: Math.abs(that.data.canvasObj.origY - pointer.y) });
                        canvas.renderAll();
*/
                        var tempRect = canvas.getActiveObject();
                                                    
                        if (data.canvasObj.isDown == true && data.canvasObj.freeDrawing == true){

                            var pointer = canvas.getPointer(evt.e);
                            var uuid = that.data.uuid;
                            // var uuid = $("#imgBBox .label_wrap .category_wrap .cate_wp.selected")[0].id;
                            var canvs = canvas.getObjects();
                            //for(var i=0; i<canvs.length; i++){
                            //    if(canvs[i]['uuid'] != uuid){
                            //        canvs[i].lockMovementX = true;
                            //        canvs[i].lockMovementY = true;
                            //    }
                            //}
                            //
                                
                            if(pointer.x < 0){
                                pointer.x = 0;
                            }
                            if(pointer.y < 0){
                                pointer.y = 0;
                            }
                            if(pointer.x > canvas.getWidth()){
                                pointer.x = canvas.getWidth();
                            }
                            if(pointer.y > canvas.getHeight()){
                                pointer.y = canvas.getHeight();
                            }
                            
                            if(data.canvasObj.origX > pointer.x){
                                tempRect.set({ left: pointer.x });
                            }else{
                                tempRect.set({ left: data.canvasObj.origX });
                            }
                            if(data.canvasObj.origY > pointer.y){
                                tempRect.set({ top: pointer.y });
                            }else{
                                tempRect.set({ top: data.canvasObj.origY });
                            }
                            
                            tempRect.set({ width: Math.abs(data.canvasObj.origX - pointer.x) });
                            tempRect.set({ height: Math.abs(data.canvasObj.origY - pointer.y) });
                            
                            canvas.renderAll();
                            
                        }else if(data.canvasObj.isDown==true && evt.target == null) {
                            const zoom = canvas.getZoom();
                            
                            if (this.viewportTransform[4] + evt.e.movementX >= 0) {
                                return;
                            } else if (this.viewportTransform[4] + evt.e.movementX < canvas.getWidth() - canvas.getWidth() * zoom) {
                                return;
                            } 
                            if (this.viewportTransform[5] + evt.e.movementY >= 0) {
                                return;
                            } else if (this.viewportTransform[5] + evt.e.movementY < canvas.getHeight() - canvas.getHeight() * zoom) {
                                return;
                            }	
                            const delta = new fabric.Point(evt.e.movementX, evt.e.movementY);
                            canvas.relativePan(delta);
                        }

                    });                    
                },

                upEvt : function(){
                    var  that = this;
                    var canvas = that.data.canvas;
                    canvas.on('mouse:up', function(o) {
                    		var uuid = that.data.uuid;    
                    		
                    		that.data.canvasObj.isDown = false;
                            that.data.canvasObj.freeDrawing = false;

                            var tempRect = canvas.getActiveObject();
                            if(tempRect == null && tempRect == undefined){
                                return false;
                            }

							var iw = that.data.scaleFactor.origWidth;
							var ih = that.data.scaleFactor.origHeight;
							var sf = that.data.scaleFactor.ratio;
							var minBboxSize = that.data.scaleFactor.minBboxSize;
							
							if(tempRect.width < minBboxSize){
								const tw = tempRect.width;
								tempRect.set({width : minBboxSize});
								// 우측 가장자리
								if(((tempRect.left/sf) + (tempRect.width/sf)) > iw){
									tempRect.set({width : minBboxSize, left: tempRect.left - (minBboxSize-tw) });
								}								
								canvas.renderAll();
							}
							if(tempRect.height < minBboxSize){
								const th = tempRect.height;
								tempRect.set({height : minBboxSize});
								// 하단 가장자리
								if(((tempRect.top/sf) + (tempRect.height/sf)) > ih){
									tempRect.set({height : minBboxSize, top: tempRect.top - (minBboxSize-th) });
								}									
								canvas.renderAll();
							}                            
							
							if(!o.target || o.target != tempRect){
								that.saveMetaData(tempRect, uuid);
							} else {
								that.saveMetaData(tempRect, uuid);
							}
                            
                            var newRect = that.rescale(that.data.meta[uuid]['rectData'],true);                     
                            
                            // that.renderCropImg(tempRect, uuid);
                            that.renderCropImg(newRect, uuid);
                            that.pt.find(".canvas_wrap.crop").css("display","flex");
                            tempRect.setCoords();
                            
                            var text = "";
                            text += "x: "+tempRect.left+" ";
                            text += " / ";
                            text += "y: "+tempRect.top+" ";
                            text += " / ";
                            text += "width: "+tempRect.width+" ";
                            text += " / ";
                            text += "height: "+tempRect.height+" ";
                            that.pt.find(".coord .crop span").html(text);

                            var ratio = that.data.scaleFactor.ratio;
                            var ow = that.data.scaleFactor.origWidth;
                            var oh = that.data.scaleFactor.origHeight;
                            var orig_text = "";
                            orig_text += "x: "+ newRect.left +" ";
                            orig_text += " / ";
                            orig_text += "y: "+ newRect.top +" ";
                            orig_text += " / ";
                            if(newRect.width > that.data.scaleFactor.origWidth){
                            	orig_text += "width: "+ (newRect.width - (newRect.width-ow)) +" ";
                            } else {
                            	orig_text += "width: "+ newRect.width +" ";
                            }
                            orig_text += " / ";
                            orig_text += "height: "+ newRect.height +" ";
                            that.pt.find(".coord .orig_coord span").html(orig_text);                             
                    });                    
                },     

                wheelEvt : function(){
                    var  that = this;
                    var canvas = that.data.canvas;
                    canvas.on("mouse:wheel",function(evt){
// 							console.log("mouse wheel!",evt);
                        //클릭 이벤트가 없을경우만 실행
                        if(that.data.canvasObj.isDown == false){
                            const delta = evt.e.deltaY;
                            const pointer = canvas.getPointer(evt.e);
                            let zoom = canvas.getZoom();
                            zoom = zoom + delta/200;
                            
                            // jh.sa : zoom 확대 시에 rectgon point 크기가 커지던 문제 수정
                            let allPoints = canvas.getObjects("point");
                            $.each(allPoints, function(i, obj){
                                if (zoom > 10) zoom = 10;
                                if (zoom < 0.8) zoom = 0.8;							
                                obj.set({
                                    scaleX: 1/zoom,
                                    scaleY: 1/zoom
                                });
                            });
                            
                            //최대크기 : 10(10이상시 크기변화가 크지않음), 최소크기 : 0.8
                            if (zoom > 10) zoom = 10;
                            if (zoom < 0.8) zoom = 0.8;
                            canvas.zoomToPoint({ x: evt.e.offsetX, y: evt.e.offsetY }, zoom);
                            evt.e.preventDefault();
                            evt.e.stopPropagation();
                            
                            //줌이 1보다 작을때 컨버스를 중앙에
                            if (zoom < 1) {
                                this.viewportTransform[4] = (this.getWidth() - this.getWidth() * zoom) / 2;
                                this.viewportTransform[5] = (this.getHeight() - this.getHeight() * zoom) / 2;
                            } else {
                                if (this.viewportTransform[4] >= 0) {
                                    this.viewportTransform[4] = 0;
                                } else if (this.viewportTransform[4] < canvas.getWidth() - canvas.getWidth() * zoom) {
                                    this.viewportTransform[4] = canvas.getWidth() - canvas.getWidth() * zoom;
                                }
                                if (this.viewportTransform[5] >= 0) {
                                    this.viewportTransform[5] = 0;
                                } else if (this.viewportTransform[5] < canvas.getHeight() - canvas.getHeight() * zoom) {
                                    this.viewportTransform[5] = canvas.getHeight() - canvas.getHeight() * zoom;
                                }
                            }
                            
                            this.renderAll();
                        }
                        
                    });                    
                },      
                
                objMovingEvt : function(){
                    var  that = this;
                    var canvas = that.data.canvas;
                    that.data.canvas.on("object:moving",function(evt){
                        var rects = canvas.getObjects();
// 							for(var i = 0; i<rects.length; i++){
// 								if(rects[i].uuid == evt.target.uuid){
// 									var tempRect = rects[i];
// 									break;
// 								}
// 							}							
                        var tempRect = that.data.canvas.getActiveObject();
                        
                        tempRect = {
                                left : evt.target.left,
                                top : evt.target.top,
                                width : evt.target.width,
                                height : evt.target.height,
                        }
                        
                        if(( tempRect.left + tempRect.width ) > canvas.getWidth() ){
                            tempRect.left = canvas.getWidth() - tempRect.width;
                        }
                        if(( tempRect.top + tempRect.height ) > canvas.getHeight() ){
                            tempRect.top = canvas.getHeight() - tempRect.height;
                        }
                        if(tempRect.width > canvas.getWidth()){
                            tempRect.width = canvas.getWidth();
                        }
                        if(tempRect.height > canvas.getHeight()){
                            tempRect.height = canvas.getHeight();
                        }
                        if(tempRect.left < 0){
                            tempRect.left = 0;
                        }
                        if(tempRect.top < 0){
                            tempRect.top = 0;
                        }
                        evt.target.left = tempRect.left;
                        evt.target.top = tempRect.top;	
                        
                    });                    
                },

                objModifiedEvt : function(){
                    var  that = this;
                    var canvas = that.data.canvas;
                    canvas.on("object:modified",function(evt){
                        var canvs = canvas.getObjects();
                        for(var i=0; i<canvs.length; i++){
                            canvs[i].lockScalingX = false;
                            canvs[i].lockScalingY = false;
                            canvs[i].lockMovementX = false;
                            canvs[i].lockMovementY = false;
                        }
                    });                    
                },

                objScalingEvt : function(){
                    var  that = this;

                    var canvas = that.data.canvas;
						
                    canvas.on("object:scaling",function(evt){
// 							$("#labeller-video .vjs-progress-control").hide();
                        
                        var tempRect = that.data.canvas.getActiveObject();
                        var pointer = canvas.getPointer(evt.e);
                        var minBboxSize = that.data.scaleFactor.minBboxSize;
                        
                        tempRect.width = evt.target.getScaledWidth();
                        tempRect.left = evt.target.left;
                        tempRect.height = evt.target.getScaledHeight();
                        tempRect.top = evt.target.top;
                        
                        // selection pointer 별 예외처리
                        switch (evt.transform.corner){
                            case "tl":
                                if(pointer.x >= tempRect.aCoords.tr.x-minBboxSize){
                                    pointer.x = tempRect.aCoords.tr.x-minBboxSize;
                                    evt.target.left = pointer.x;
                                }
                                if(pointer.y >= tempRect.aCoords.bl.y-minBboxSize){
                                    pointer.y = tempRect.aCoords.bl.y-minBboxSize;
                                    evt.target.top = pointer.y;
                                }
                                
                                tempRect.set({
                                    width : Math.abs(tempRect.aCoords.tr.x - pointer.x),
                                    height : Math.abs(tempRect.aCoords.bl.y - pointer.y)
                                });
                                evt.target.scaleX = tempRect.width / evt.target.width;
                                evt.target.scaleY = tempRect.height / evt.target.height;
                                break;
                            case "mt":
                                if(pointer.y >= tempRect.aCoords.br.y-minBboxSize){
                                    pointer.y = tempRect.aCoords.br.y-minBboxSize;
                                    evt.target.top = pointer.y;
                                }
                                
                                tempRect.set({
                                    width : Math.abs(tempRect.aCoords.tr.x - tempRect.aCoords.tl.x),
                                    height : Math.abs(tempRect.aCoords.br.y - pointer.y)
                                });
                                evt.target.scaleX = tempRect.width / evt.target.width;
                                evt.target.scaleY = tempRect.height / evt.target.height;
                                break;
                            case "tr":
                                if(pointer.x <= tempRect.aCoords.tl.x-minBboxSize){
                                    pointer.x = tempRect.aCoords.tl.x;
                                    evt.target.left = pointer.x;
                                }
                                if(pointer.y >= tempRect.aCoords.br.y-minBboxSize){
                                    pointer.y = tempRect.aCoords.br.y-minBboxSize;
                                    evt.target.top = pointer.y;
                                }
                                
                                tempRect.set({
                                    width : Math.abs(tempRect.aCoords.tl.x - pointer.x),
                                    height : Math.abs(tempRect.aCoords.br.y - pointer.y) 
                                });
                                evt.target.scaleX = tempRect.width / evt.target.width;
                                evt.target.scaleY = tempRect.height / evt.target.height;
                                break;
                            case "bl":
                                if(pointer.x >= tempRect.aCoords.br.x-minBboxSize){
                                    pointer.x = tempRect.aCoords.br.x-minBboxSize;
                                    evt.target.left = pointer.x;
                                }
                                if(pointer.y <= tempRect.aCoords.tl.y+minBboxSize){
                                    pointer.y = tempRect.aCoords.tl.y;
                                    evt.target.top = pointer.y;
                                }
                                
                                tempRect.set({
                                    width : Math.abs(tempRect.aCoords.br.x - pointer.x),
                                    height : Math.abs(tempRect.aCoords.tl.y - pointer.y) 
                                });
                                evt.target.scaleX = tempRect.width / evt.target.width;
                                evt.target.scaleY = tempRect.height / evt.target.height;
                                break;
                            case "ml":
                                if(pointer.x >= tempRect.aCoords.tr.x-minBboxSize){
                                    pointer.x = tempRect.aCoords.tr.x-minBboxSize;
                                    evt.target.left = pointer.x;
                                }
                                tempRect.set({
                                    width : Math.abs(tempRect.aCoords.tr.x - pointer.x),
                                    height : Math.abs(tempRect.aCoords.bl.y - tempRect.aCoords.tl.y)
                                });
                                evt.target.scaleX = tempRect.width / evt.target.width;
                                evt.target.scaleY = tempRect.height / evt.target.height;
                                break;
                            case "mb":
                                tempRect.set({
                                    width : Math.abs(tempRect.aCoords.tr.x - tempRect.aCoords.tl.x),
                                    height : Math.abs(tempRect.aCoords.tr.y - pointer.y)
                                });
                                evt.target.scaleX = tempRect.width / evt.target.width;
                                evt.target.scaleY = tempRect.height / evt.target.height;
                                break;
                            case "mr":
                                tempRect.set({height : Math.abs(tempRect.aCoords.bl.y - tempRect.aCoords.tl.y)});
                                evt.target.scaleY = tempRect.height / evt.target.height;
                                break;
                            case "br":
                                if(pointer.x <= tempRect.aCoords.bl.x+minBboxSize){
                                    pointer.x = tempRect.aCoords.bl.x;
                                    evt.target.left = pointer.x;
                                }
                                if(pointer.y <= tempRect.aCoords.tl.y+minBboxSize){
                                    pointer.y = tempRect.aCoords.tl.y;
                                    evt.target.top = pointer.y;
                                }
                                tempRect.set({
                                    width : Math.abs(tempRect.aCoords.bl.x - pointer.x),
                                    height : Math.abs(tempRect.aCoords.tl.y - pointer.y) 
                                });
// 									evt.target.scaleX = tempRect.width / evt.target.width;
// 									evt.target.scaleY = tempRect.height / evt.target.height;
                                break;
                        }
                        
                        if(tempRect.left < 0){
                            tempRect.left = 0;
                            evt.target.left = tempRect.left;
                            tempRect.width = evt.target.aCoords.br.x-0;
                            evt.target.scaleX = tempRect.width / evt.target.width;
                        }
                        
                        if(tempRect.top < 0){
                            tempRect.top = 0;
                            evt.target.top = tempRect.top;
                            tempRect.height = evt.target.aCoords.br.y-0;
                            evt.target.scaleY = tempRect.height / evt.target.height;
                        }
                        
// 							if(tempRect.left+tempRect.width > canvas.getWidth() && tempRect.width < 40) {
// 								tempRect.left = canvas.getWidth()-40;
// 								evt.target.left = tempRect.left;
// 								tempRect.width = evt.target.aCoords.tl.x+40;
// 								evt.target.scaleX = tempRect.width / evt.target.width;
// 							}
// 							if(tempRect.top+tempRect.height > canvas.getHeight() && tempRect.height < 40) {
// 								tempRect.top = canvas.getHeight()-40;
// 								evt.target.top = tempRect.top;
// 								tempRect.height = evt.target.aCoords.tl.y+40;
// 								evt.target.scaleY = tempRect.height / evt.target.height;
// 							}
                        
                        if(tempRect.left+tempRect.width > canvas.getWidth()) {
                            tempRect.width = canvas.getWidth() - tempRect.left;
                            evt.target.scaleX = tempRect.width / evt.target.width;
                        }
                        
                        if(tempRect.top + tempRect.height > canvas.getHeight()) {
                            tempRect.height = canvas.getHeight() - tempRect.top;
                            evt.target.scaleY = tempRect.height / evt.target.height;
                        }
                        
                        if(tempRect.width < minBboxSize){
                            tempRect.set({width : minBboxSize});
                            evt.target.scaleX = tempRect.width / evt.target.width;
// 								tempRect.lockScalingX = true;
                        }
                        
                        if(tempRect.height < minBboxSize){
                            tempRect.set({height : minBboxSize});
                            evt.target.scaleY = tempRect.height / evt.target.height;
// 								tempRect.lockScalingY = true;
                        }
                        
                        
                    });                    
                },
                
//                 keydownEvt : function(){
//                 	var that = this;
//                 	var canvas = that.data.canvas;
                	
//                 	$(document).off("keydown").on("keydown", function(e){
//                 		var STEP = 1;
//                 		// prevent scrolling
                		
//                 		var keyCode = e.keyCode || e.which;
//                 		var activeGroup = canvas.getActiveObjects();
//                 		if(activeGroup.length > 0){
//                 			e.preventDefault();
//                     		if(Array.isArray(activeGroup)){
//                     			activeGroup.forEach(function(obj){
//                     				switch(keyCode){
//     	                		         case 37: // left
//     	                		             obj.left = obj.left - STEP;
//     	                		             break;
//     	                		           case 38: // up
//     	                		             obj.top = obj.top - STEP;
//     	                		             break;
//     	                		           case 39: // right
//     	                		             obj.left = obj.left + STEP;
//     	                		             break;
//     	                		           case 40: // down
//     	                		             obj.top = obj.top + STEP;
//     	                		             break;
//                     				}
//                     				obj.setCoords();
//                     			});
//                     			canvas.renderAll();
//                     		}
//                 		}
//                 	});
//                 },
                
				// Canvas Controlbar 
				// Move to Left and Top
				moveBox : function(direction) {
					var that = this;
					var canvas = that.data.canvas; 
					var step = 1;
					var tempRect = canvas.getActiveObject();
					
                    if(tempRect == null && tempRect == undefined){
                        return false;
                    }
                    
					switch(direction){
						case "left":
							tempRect.left = tempRect.left - step;
							break;
						case "up":
							tempRect.top = tempRect.top - step;
							break;
						case "right":
							tempRect.left = tempRect.left + step;
							break;
						case "down":
							tempRect.top = tempRect.top + step;
							break;
					}
					tempRect.setCoords();
					canvas.renderAll();
					
					var newRect = that.rescale(tempRect,true); 
					that.renderCropImg(newRect);
					
                    var text = "";
                    text += "x: "+tempRect.left+" ";
                    text += " / ";
                    text += "y: "+tempRect.top+" ";
                    text += " / ";
                    text += "width: "+tempRect.width+" ";
                    text += " / ";
                    text += "height: "+tempRect.height+" ";
                    that.pt.find(".coord .crop span").html(text);

                    var ratio = that.data.scaleFactor.ratio;
                    var orig_text = "";
                    orig_text += "x: "+ tempRect.left / ratio +" ";
                    orig_text += " / ";
                    orig_text += "y: "+ tempRect.top / ratio +" ";
                    orig_text += " / ";
                    orig_text += "width: "+ tempRect.width / ratio +" ";
                    orig_text += " / ";
                    orig_text += "height: "+ tempRect.height / ratio+" ";
                    that.pt.find(".coord .orig_coord span").html(orig_text); 					
				},
				
                // Zoom In
                zoomIn : function() {
                    var  that = this;
                    var canvas = that.data.canvas;
                    var scaleFactor = that.data.scaleFactor.ratio;
                    var zoomMax = 10;
                    console.log("zoomIN");
                    if(canvas.getZoom().toFixed(5) > zoomMax){
                        console.log("zoomIn: Error: cannot zoom-in anymore");
                        return;
                    }

                    canvas.setZoom(canvas.getZoom() * 1.1);
                    var zoom = canvas.getZoom();
                    canvas.viewportTransform[4] = (canvas.getWidth() - canvas.getWidth() * zoom) / 2;
                    canvas.viewportTransform[5] = (canvas.getHeight() - canvas.getHeight() * zoom) / 2;                      
                    //canvas.setHeight(canvas.getHeight() * scaleFactor);
                    //canvas.setWidth(canvas.getWidth() * scaleFactor);
                    canvas.renderAll();
                },

                // Zoom Out
                zoomOut : function() {
                    var  that = this;
                    var canvas = that.data.canvas;
                    var scaleFactor = that.data.scaleFactor.ratio;

                    if( canvas.getZoom().toFixed(5) <= 0.8 ){
                        console.log("zoomOut: Error: cannot zoom-out anymore");
                        return;
                    }

                    canvas.setZoom(canvas.getZoom() / 1.1);
                    var zoom = canvas.getZoom();
                    canvas.viewportTransform[4] = (canvas.getWidth() - canvas.getWidth() * zoom) / 2;
                    canvas.viewportTransform[5] = (canvas.getHeight() - canvas.getHeight() * zoom) / 2;                  
                    //canvas.setHeight(canvas.getHeight() / scaleFactor);
                    //canvas.setWidth(canvas.getWidth() / scaleFactor);
                    canvas.renderAll();

                },

                // Reset Zoom
                resetZoom : function() {
                    var  that = this;
                    var canvas = that.data.canvas;

                    //canvas.setHeight(canvas.getHeight() /canvas.getZoom() );
                    //canvas.setWidth(canvas.getWidth() / canvas.getZoom() );
                    canvas.setZoom(0.8);
                    
                    var zoom = canvas.getZoom();
                    if(zoom < 1){
                        canvas.viewportTransform[4] = (canvas.getWidth() - canvas.getWidth() * zoom) / 2;
                        canvas.viewportTransform[5] = (canvas.getHeight() - canvas.getHeight() * zoom) / 2;
                    }
                    canvas.renderAll();

                    that.getFabricCanvases().forEach(function(item){
                        item.css('left', 0);
                        item.css('top', 0);
                    });

                },           

				listener: function(){
					var that = this;
					

					that.pt.find(".btn_submit").off("click").on("click",function(){
					
						if(xValidator(".input_wrap")){
							that.insertData();
						}
					});
					
                    that.pt.find("#image_load").off("click").on("click", function(e){
                        that.clearAllData();
                        that.loadImage();
                    });
                    
                    that.pt.find("#image_file").off("change").on("change", function(e){
                    	$(this).data("changed", true);
                    	if($(this).val() != ""){
                            if(window.FileReader){
                            	var filename = $(this)[0].files[0].name;
                            } else {
                            	var filename = $(this).val().split('/').pop().split('\\').pop();
                            }
                            $(this).siblings('.input_cont').val(filename);
                            that.pt.find(".canvas_wrap.crop").css("display","none");
                    		that.clearAllData();
                            that.loadImage();
                    	} else {
                    		$(this).siblings('.input_cont').val("");
                    		that.clearAllData();
                    		that.data.canvas.clear();
                    		that.pt.find(".canvas_wrap.crop").css("display","none");
                    	}
                    });
    
                    that.pt.find(".btn_zoom").off("click").on("click", function(e){
                        if($(this).hasClass("in")){
                            that.zoomIn();
                        } else if($(this).hasClass("out")){
                            that.zoomOut();
                        } else if($(this).hasClass("reset")){
                            that.resetZoom();
                        }
                    });					
                    
                    that.pt.find(".btn_move").off("click").on("click", function(e){
                    	var direction = "";
                    	if($(this).hasClass("left")){
                    		direction = "left";
                    	} else if($(this).hasClass("right")){
                    		direction = "right";
                    	} else if($(this).hasClass("up")){
                    		direction = "up";
                    	} else if($(this).hasClass("down")){
                    		direction = "down";
                    	}
                    	that.moveBox(direction);
                    });
					
				},
				
				insertData: function(){
					var that = this;
					var meta = that.data.meta;
					var keys = Object.keys(meta);
					var data = [];
					
					for(var i=0; i<keys.length; i++){
						if(!meta[keys[i]]['rectData']){
							alert("도면 영역을 지정해주세요.");
							return false;
						}
						
						that.checkRectData(meta[keys[i]]['rectData']);
						
						var temp = that.rescale(meta[keys[i]]['rectData'], true);
						
						var tmpRect = temp['left']+','+temp['top']+','+temp['width']+','+temp['height'];
						data.push({
							meta_id : meta[keys[i]]["id"],
							info : tmpRect,	
						});						
					}
					
					var ajaxData = {
							data : JSON.stringify(data)
					};
					
					if(data.length <=0){
						alert("저장할 데이터가 없습니다.");
						return false;
					}					
					console.log(data[0]);
					$.ajax({
// 						url:  baseUrl + "office/getOfiiceList.json",
					   	data : ajaxData,
					   	success : function(res){
					   		console.log("=====getOfiiceList=====", res);
					   		
					   		if(res.result.code == "200"){
						   		
					   		}
					   	},
					    error:function(request,status,error){
					         alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
					    }

					}); 
					
				},
				
                initRect : function(obj,uuid){
                    var that = this;
                    var tempRect = {};
                    tempRect = new fabric.Rect( obj );

                    that.data.canvas.add(tempRect);
                    that.data.canvas.setActiveObject(tempRect);
                    that.data.canvas.renderAll();
                },

                getRectObject : function(rectData, uuid){
                    var that = this;
                    var object = {};

                    object = {
                        left : rectData.left,
                        top : rectData.top,
                        width : rectData.width,
                        height : rectData.height,
                        uuid : uuid,
                        stroke : "blue",
                        //fill : "transparent",
                        fill : "rgba(0,0,255,0.2)",
                        type : 'rect',
                        strokeWidth : 2,
                        strokeWidthUnscaled:2,
                        lockRotation : true,
                        noScaleCache : false,
                        lockUniScaling : false,
                        lockScalingFlip : true,
                        transparentCorners : false,
                        strokeUniform : true,                                                
                        cornerColor : "blue",
                        cornerSize : 10,                        
                    }

                    return object;
                },

                initMetaData : function(uuid){
                    var that = this;

                    that.data.meta[uuid] = {
                        id : uuid,
                        name : null,
                    };
                },
                
                saveMetaData : function(newRect, uuid){
                	var that = this;
                	var meta = that.data.meta;
                	var keys = Object.keys(meta);
                	
                	var tempRect = {
                		top : newRect.top,
                		left : newRect.left,
                		width : newRect.width,
                		height : newRect.height,
                	};
                	meta[uuid]['id'] = uuid;
                	meta[uuid]['rectData'] = tempRect;
                },

                loadImage : function(){
                    var that = this;
                    var canvas = that.data.canvas;
                    var clsImage = that.data.clsImage;
                    var tmpObj = {};
                    var uuid = that.generateUUID();
                    console.log("load");
                    if( typeof window.FileReader !== 'function' )
                    {
                        alert("FileReader is not supported");
                        return;
                    }
        
                    var inputFile = document.getElementById('image_file');
                    var clsFileReader = new FileReader();
                    clsFileReader.onload = function(){
                        that.data.clsImage = new Image();
                        that.data.clsImage.onload = function(){
                            //var canvas = document.getElementById("canvas");
                            //canvas.width = clsImage.width;
                            //canvas.height = clsImage.height;

                            tempObj = {
                                width : this.naturalWidth,
                                height : this.naturalHeight,
                            };

                            that.rescaleTempImg(this);

                            $.when(that.getScaleFactor(tempObj)).done(function(){
                                canvas.setHeight(tempObj.height * that.data.scaleFactor.ratio);
                                canvas.setBackgroundImage(that.data.clsImage.src,canvas.renderAll.bind(canvas),{
                                    scaleX : that.data.scaleFactor.ratio,
                                    scaleY : that.data.scaleFactor.ratio,
                                });
								that.resetZoom();                               
                            });

                            var text = "";
                            text += "width: "+this.naturalWidth+" ";
                            text += " / ";
                            text += "height: "+this.naturalHeight+" ";
                            text += " / ";
                            text += "scaleFactor: "+that.data.scaleFactor.ratio;

                            that.pt.find(".coord .orig span").html(text);                            

                            //canvas.setWidth(that.data.clsImage.width);
                            //canvas.setHeight(that.data.clsImage.height);
                            //canvas.calcOffset();
                            //canvas.renderAll();
                            //canvas.setBackgroundImage(that.data.clsImage.src,canvas.renderAll.bind(canvas),{
                            //    scaleX : that.data.scaleFactor.ratio,
                            //    scaleY : that.data.scaleFactor.ratio,
                            //});
                            canvas.imgInfo = that.data.clsImage;

                            that.data.uuid = uuid;
                            
                            that.data.iCropLeft = 100;
                            that.data.iCropTop = 100;
                            that.data.iCropWidth = that.data.clsImage.width - 200;
                            that.data.iCropHeight = that.data.clsImage.height - 200;
                            that.data.iImageWidth = that.data.clsImage.width;
                            that.data.iImageHeight = that.data.clsImage.height;
                            
                            //that.drawCropRect();
                            //that.addCropMoveEvent();
                        };
        
                        that.data.clsImage.src = clsFileReader.result;
                    };
                    
                    clsFileReader.readAsDataURL(inputFile.files[0]);
                    that.data.uuid = uuid;
                    that.initMetaData(uuid);
                },

                rescaleTempImg : function(img, w, h){
                    var that = this;

                    var canvas_max_width = 800;
                    var canvas_max_height = 600;

                    if(w != null && h != null){
                        canvas_max_width = w;
                        canvas_max_height = h;
                    }

                    // canvas 최대 너비와 높이에 맞춰 원본 이미지 비율대로 이미지 크기 설정
                    let scaleFactor = 0;
                    if(canvas_max_height/canvas_max_width >= img.naturalHeight/img.naturalWidth  ){
                        scaleFactor = canvas_max_width/img.naturalWidth;
                    } else {
                        scaleFactor = canvas_max_height/img.naturalHeight;
                    }
                    
                    let imgInfo = that.data.scaleFactor;
                    imgInfo.scaleFactor = scaleFactor;
                    imgInfo.width = img.naturalWidth;
                    imgInfo.height = img.naturalHeight;					
                    
                    that.data.canvas.setWidth(img.naturalWidth*scaleFactor);
                    that.data.canvas.setHeight(img.naturalHeight*scaleFactor);
                    that.data.canvas.calcOffset();
                    that.data.canvas.renderAll();                    
                },

                rescale : function(rectData, isSave){
                    var that = this;
                    var scaleFactor = that.data.scaleFactor.ratio;
                    var tempData = [];

                    if(!isSave){
                        tempData = {};
                        tempData.top = rectData.top * scaleFactor;
                        tempData.left = rectData.left * scaleFactor;
                        tempData.width = rectData.width * scaleFactor;
                        tempData.height = rectData.height * scaleFactor;
                    }else{
                        tempData = {};
                        tempData.top = rectData.top / scaleFactor;
                        tempData.left = rectData.left / scaleFactor;
                        tempData.width = rectData.width / scaleFactor;
                        tempData.height = rectData.height / scaleFactor;
                    }
                    
                    return tempData;                    
                },

                // gap between real video size and web page
                getScaleFactor : function(imgObj){
                    var that = this;
                    var minBboxSize = 30;
// 						var imgObj = this.checkImageSize(dataAddr);
                    // 실제 비디오 크기 기준
                    // scaleFactor > 1 : 실제 비디오가 캔버스 크기보다 큼
                    // scaleFactor < 1 : 실제 비디오가 캔버스 크기보다 작음
                    that.data.scaleFactor.origWidth = imgObj['width'];
                    that.data.scaleFactor.origHeight = imgObj['height'];
                    that.data.scaleFactor.ratio = $("#canvas").width() / that.data.scaleFactor.origWidth;
                    that.data.scaleFactor.minBboxSize = that.data.scaleFactor.ratio * minBboxSize;
                    
                }, // scalefactor end              
                
                getFabricCanvases : function(){
                    var that = this;
                    var fabricCanvasCollection;
                    if(!fabricCanvasCollection){
                        fabricCanvasCollection = [];
                        var fabricCanvas = $('.canvas-container canvas');
                        fabricCanvas.each(function(index, item) {
                            fabricCanvasCollection.push($(item));
                        });
                    }

                    return fabricCanvasCollection;
                },                
                
                clearAllData : function(){
                    var that = this;
                    that.data.scaleFactor = { origWidth: 0, origHeight: 0, ratio: 1, minBboxSize: 0};
                    that.clearCanvas();
                    that.clearMeta();
                    that.clearRect();
                },
    
                clearCanvas : function(){
                    var that = this;
    
                    that.data.canvas.clear();
                },
    
                clearMeta : function(){
                    var that = this;
                    that.data.meta = {};
                },
    
                clearRect : function(){
                    var that = this;
    
                    var canv = that.data.canvas.getObjects();
                    that.data.canvas.remove(canv);
                    that.data.rectObj = {};
                    
                },
                
                checkRectData : function(rectData) {
                    var that = this;           
                    var ow = that.data.scaleFactor.origWidth;
                    var oh = that.data.scaleFactor.origHeight;               
                    var sf = that.data.scaleFactor.ratio;  
                    var minBboxSize = that.data.scaleFactor.minBboxSize;

                    // 우측 가장자리 
                    if(((rectData.left / sf) + (rectData.width / sf)) > ow){
                    	rectData.width = (ow * sf) - rectData.left;
                        if(rectData.width < minBboxSize){
							const tw = rectData.width;                                	
                        	rectData.width = minBboxSize;
                        	rectData.left = rectData.left - (minBboxSize-tw);
                        }
                    }
                    // 하단 가장자리
                    if(((rectData.top / sf) + (rectData.height / sf)) > oh){
                    	rectData.height = (oh * sf) - rectData.top;
                        if(rectData.height < minBboxSize){
                        	const th = rectData.height;
                        	rectData.height = minBboxSize;
                        	rectData.top = rectData.top - (minBboxSize-th);                                	
                        }                        	
                    }    
                    
                },                

                generateUUID : function(){
                    var d = new Date().getTime();
                    if(window.performance && typeof window.performance.now === "function"){
                        d += performance.now(); //use high-precision timer if available
                    }
                    var uuid = 'xxxxxxxx-xxxx-xxxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
                        var r = (d + Math.random()*16)%16 | 0;
                        d = Math.floor(d/16);
                        return (c=='x' ? r : (r&0x3|0x8)).toString(16);
                    });
                    return uuid;
                },				
				
                renderCropImg : function(newRect, uuid){
                    var that = this;
                    var scaleFactor = that.data.scaleFactor.ratio;

                    var pt = that.pt.find("#crop_img");
                    var ctx = pt[0].getContext('2d');

                    var panelW = 800;
                    var panelH = 600;
                    
                    var newWidth = 0;
                    var newHeight = 0;
                    
                    var scaleW = newRect.width/panelW;
                    var scaleH = newRect.height/panelH;
                    
                    if(scaleW>=scaleH){
                        newWidth = newRect.width/scaleW;
                        newHeight = newRect.height/scaleW;
                    }else{
                        newWidth = newRect.width/scaleH;
                        newHeight = newRect.height/scaleH;
                    }
                    
                    pt[0].width = newWidth;
                    pt[0].height = newHeight;
                    
                    ctx.clearRect(0, 0, panelW, panelH);
                    ctx.drawImage(that.data.canvas.imgInfo,newRect.left,newRect.top,newRect.width,newRect.height,0,0,newWidth,newHeight);                   
                },				
			};
		</script>
	</body>
</html>