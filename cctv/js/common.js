/* 쿠키 관련 */
function setCookie(cookieName, value, exdays){
    var exdate = new Date();
    exdate.setDate(exdate.getDate() + exdays);
    var cookieValue = escape(value) + ((exdays==null) ? "" : "; expires=" + exdate.toGMTString());
    document.cookie = cookieName + "=" + cookieValue;
}
 
function deleteCookie(cookieName){
    var expireDate = new Date();
    expireDate.setDate(expireDate.getDate() - 1); //어제날짜를 쿠키 소멸날짜로 설정
    document.cookie = cookieName + "= " + "; expires=" + expireDate.toGMTString();
}
 
function getCookie(cookieName) {
    cookieName = cookieName + '=';
    var cookieData = document.cookie;
    var start = cookieData.indexOf(cookieName);
    var cookieValue = '';
    if(start != -1){
        start += cookieName.length;
        var end = cookieData.indexOf(';', start);
        if(end == -1)end = cookieData.length;
        cookieValue = cookieData.substring(start, end);
    }
    return unescape(cookieValue);
}

    
    
/* URI */
function modifyUri(qs){
	if (history.pushState) {
	    var newurl = window.location.protocol + "//" + window.location.host + window.location.pathname + "?" + qs;
	    window.history.pushState({path:newurl},"",newurl);
	}
}

function getUpDownColor(value){
	value =  value * 1;
	var color = "#333";
	if(value > 0) color = "up_color";
	else if(value < 0) color = "down_color";
	
	return color;
}

/* 데이터 없는 경우 UI 처리 */
function showNodata(target){
	$(target).removeAttr("_echarts_instance_").removeAttr("style").html("").addClass("nodata");
}

/* 로딩 UI */
function showLoading(target){
	var h = $(target).outerHeight()/2, w = $(target).outerWidth()/2;
	var s = 50 /2; // loading image size
	
	console.log(w, s)
	var top = h-s, left = w-s;
	if(top <= 0) top = 0;
	else if(left <= 0) left = 0;
	
// 			console.log(target, h,s, h-s, w-s)
	var lc = "<div id='loading' class=''><div class='loading_img filter_color' style='top: "+top+"px; left: "+left+"px;'></div></div>";
	
	$(target).append(lc);
}

function hideLoading(target){
	$(target).find("#loading").remove();
}

function getSession(){
// 			var sessionResult;
// 			$.ajax({
// 			   	url :  baseUrl + "auth/getSession.json",
// 			   	data : {},
// 			   	type : "POST",
// 			   	async: false,
// 			   	success : function(res){
// 					console.log("=====getSession=====", res);
// 					sessionResult = res.result;
// 			   	},
// 			   	error : function(err){
// 			   		 console.log("ERROR!!", err);
// 			   	}
// 			});	
	
// 			return sessionResult;
}


window.dayOfWeek =["일","월","화","수","목","금","토"];

/* 로그인 체크 */
function loginCheck(){
	if(typeof loginUserInfo == "undefined" || $.isEmptyObject(loginUserInfo) == true){
//		alert("로그인 후 이용 가능합니다.");
		return false;
	} else {
		return true;
	}
}

/* object */
// Object.keys
if (!Object.keys) {
	  Object.keys = (function() {
	    'use strict';
	    var hasOwnProperty = Object.prototype.hasOwnProperty,
	        hasDontEnumBug = !({ toString: null }).propertyIsEnumerable('toString'),
	        dontEnums = [
	          'toString',
	          'toLocaleString',
	          'valueOf',
	          'hasOwnProperty',
	          'isPrototypeOf',
	          'propertyIsEnumerable',
	          'constructor'
	        ],
	        dontEnumsLength = dontEnums.length;

	    return function(obj) {
	      if (typeof obj !== 'function' && (typeof obj !== 'object' || obj === null)) {
	        throw new TypeError('Object.keys called on non-object');
	      }

	      var result = [], prop, i;

	      for (prop in obj) {
	        if (hasOwnProperty.call(obj, prop)) {
	          result.push(prop);
	        }
	      }

	      if (hasDontEnumBug) {
	        for (i = 0; i < dontEnumsLength; i++) {
	          if (hasOwnProperty.call(obj, dontEnums[i])) {
	            result.push(dontEnums[i]);
	          }
	        }
	      }
	      return result;
	    };
	  }());
	}


// comma
Number.prototype.comma = function(){
    if(this==0) return 0;
 
    var reg = /(^[+-]?\d+)(\d{3})/;
    var n = (this + '');
 
    while (reg.test(n)) n = n.replace(reg, '$1' + ',' + '$2');
 
    return n;
};

String.prototype.expandExponential = function(){
    return this.replace(/^([+-])?(\d+).?(\d*)[eE]([-+]?\d+)$/, function(x, s, n, f, c){
        var l = +c < 0, i = n.length + +c, x = (l ? n : f).length,
        c = ((c = Math.abs(c)) >= x ? c - x + l : 0),
        z = (new Array(c + 1)).join("0"), r = n + f;
        return (s || "") + (l ? r = z + r : r += z).substr(0, i += l ? z.length : 0) + (i < r.length ? "." + r.substr(i) : "");
    });
};

/* number comma 자르기 */
function numberFormat(val){
	// (-) 빼고,
	// 1이상인 경우, 소수점 2째자리까지 (셋째자리에서 반올림)
	// 1미만인 경우, 소수점 아래 0이아닌 다른수가 나온자리부터 4째자리까지
	
	var numType = Number(val) < 0 ? -1 : 1;

	val = numType == -1 ? Number(val)*-1 : Number(val);
	
	if(val==0){
		var n = "0";
	} else if(val<1){
		var f = 4;
		
		var sp = Number(Number(val).toPrecision(f)).toPrecision();
		var n = sp.expandExponential();
		
	} else {
		var f = 2;
		val = String(val).indexOf(".") > -1 ? Number(val).toFixed(f) : Number(val);
		 
	    var reg = /(^[+-]?\d+)(\d{3})/;
	    var n = (val + "");
	 
	    while (reg.test(n)) n = n.replace(reg, "$1" + "," + "$2");
	}

    return numType == -1 ? "-" + n : n;
}


function getByteLength(s,b,i,c){
    for(b=i=0;c=s.charCodeAt(i++);b+=c>>11?3:c>>7?2:1);
    return b;
}

/* byte 단위 변환 */
function bytesToSize(bytes) {
	   var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
	   if (bytes == 0) return '0 Byte';
	   var i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)));
	   
	   if(bytes < 1024 ) return Math.round(bytes / Math.pow(1024, i), 2) + '' + sizes[i];
	   else return (bytes / Math.pow(1024, i)).toFixed(2) + '' + sizes[i];
//	   return Math.round(bytes / Math.pow(1024, i), 2) + '' + sizes[i];
};

// 공백 사용 못 하게
function noSpaceForm(obj) 
{             
    var str_space = /\s/;               // 공백 체크
    if(str_space.exec(obj.value)) 
    {     // 공백 체크
        alert("해당 항목에는 공백을 사용할 수 없습니다.");
        obj.focus();
        obj.value = obj.value.replace(/\s/g,""); // 공백제거
        return false;
    }
}

// 한글 입력 방지 
function noKor(obj){
	if(obj.keyCode >= 65 && obj.keyCode <= 90){
		if($(obj.target).val().match(/[^a-zA-Z0-9~!@#$%^&*()-_=+ ]/)){
			alert("영문과 특수문자 및 숫자만 입력 가능합니다");
		}
		
		var str = $(obj.target).val().replace(/[^a-zA-Z0-9~!@#$%^&*()-_=+ ]/gi,"");
        if(str.match(/[^a-zA-Z0-9~!@#$%^&*()-_=+ ]/)){
			$(obj.target).val(str.slice(0, -1));						
		} else {
			$(obj.target).val(str);						
		}		
	}
}

// 숫자, -, . 만 입력 가능하게
function checkNum(e) {
	var keyVal = event.keyCode;
	
	if(((keyVal >= 45) && (keyVal <= 57))){
		return true;
	} else if ((keyVal >= 189) && (keyVal <= 190)){
		return true;
	} else {
		alert("숫자만 입력 가능합니다");
		return false;
	}
}

// 숫자만 입력 가능하게
function checkNum2(e){
	var keyVal = event.keyCode;
	
	if(((keyVal >= 48) && (keyVal <= 57))){
		return true;
	} else if (keyVal == 13){
		return true;
	} else {
		alert("숫자만 입력 가능합니다");
		return false;
	}
}

function lengthCheck(len){
    if($(this).data("length") == len && $(this).val().length > len){
        var string = $(this).val();
        alert("입력 가능한 텍스트 개수를 초과하였습니다");
        $(this).val(string.slice(0,len));
        return false;
    }
};

// 회원가입, 로그인 유효성 검사
function validateID(){
	var re = /^[a-z0-9]{5,15}$/; // 아이디가 적합한지 검사할 정규식
	var re2 = /[a-z]/;
	var re3 = /[0-9]/;
		
	var id = document.getElementById("uid");
	
	if(!check(re2,re3, id, "아이디는 5-15자 이내의 영문 소문자와 숫자로만 입력해주세요")) {
		return false;
	} else {
		return true;
	}
}

function check(re2, re3, id, msg){
	if(!re2.test(id.value) || !re3.test(id.value)){
		alert(msg);
		id.value= "";
		id.focus();	
		return false;
	}
	return true;

}

// 비밀번호 표준 : 영문 대소문자, 숫자, 특수문자 혼합하여 8-20자리 이내
function chkPwd(str){
	var pwd = str;
	var num = pwd.search(/[0-9]/g);
	var eng = pwd.search(/[a-z]/ig);
	var spe = pwd.search(/[`~!@@#$%^&*|₩₩₩'₩";:₩/?]/gi);
	
	if(pwd.length < 8 || pwd.length > 20){
		alert("비밀번호는 8자리 ~ 20자리 이내로 입력해주세요");
		return false;
	}
	
	if(pwd.search(/\s/) != -1){
		alert("비밀번호는 공백 없이 입력해주세요");
		return false;
	}
	
	if(num < 0 || eng < 0 || spe < 0){
		alert("비밀번호는 영문 대소문자, 숫자, 특수문자를 혼합하여 입력해주세요");
		return false;
	}
	
	return true;
}

// object key 이름으로 정렬하여 반환
function sortObject(obj){
	var that = this;
	
    var sorted = {},
    key, a = [];

    // 키이름을 추출하여 배열에 집어넣음
    for (key in obj) {
        if (obj.hasOwnProperty(key)) a.push(key);
    }
    
    // 키이름 배열을 정렬
    a.sort();
    
    // 정렬된 키이름 배열을 이용하여 object 재구성
    for (key=0; key<a.length; key++) {
        sorted[a[key]] = obj[a[key]];
    }
    
    return sorted;			
}

