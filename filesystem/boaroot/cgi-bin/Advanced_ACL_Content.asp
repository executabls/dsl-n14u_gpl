<%
tcWebApi_set("WLan_Common","editFlag","editFlag")
tcWebApi_set("WLan_Common","MBSSID_changeFlag","MBSSID_changeFlag")
tcWebApi_set("WLan_Common","MBSSID_able_Flag","MBSSID_able_Flag")
If Request_Form("editFlag") = "1" then
	tcWebApi_Set("SysInfo_Entry","w_Setting","w_Setting")
	tcWebApi_commit("SysInfo_Entry")
	
	tcWebApi_Set("WLan_Common","wl_unit","wl_unit")
	tcWebApi_Set("ACL_Entry","wl_macmode","wl_macmode")
	tcWebApi_Set("ACL_Entry","wl_maclist","wl_maclist_x")
	tcWebApi_commit("ACL_Entry")
	
	load_parameters_from_generic()
	
	tcWebApi_commit("WLan_Entry")
end if

load_parameters_to_generic()
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<html xmlns:v>

<!--Advanced_ACL_Content.asp-->
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<link rel="shortcut icon" href="/images/favicon.png">
<link rel="icon" href="/images/favicon.png">
<title>ASUS <%tcWebApi_get("String_Entry","Web_Title2","s")%> <% tcWebApi_staticGet("SysInfo_Entry","ProductTitle","s") %> - <%tcWebApi_get("String_Entry","menu5_1_4","s")%></title>
<link rel="stylesheet" type="text/css" href="/index_style.css">
<link rel="stylesheet" type="text/css" href="/form_style.css">
<script language="JavaScript" type="text/javascript" src="/state.js"></script>
<script language="JavaScript" type="text/javascript" src="/help.js"></script>
<script language="JavaScript" type="text/javascript" src="/general.js"></script>
<script language="JavaScript" type="text/javascript" src="/popup.js"></script>
<script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
<script language="JavaScript" type="text/javascript" src="/detect.js"></script>
<script language="JavaScript" type="text/javascript" src="/jquery.js"></script>
<script language="JavaScript" type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script language="JavaScript" type="text/javascript" src="/validator.js"></script>
<style>
#pull_arrow{
 	float:center;
 	cursor:pointer;
 	border:2px outset #EFEFEF;
 	background-color:#CCC;
 	padding:3px 2px 4px 0px;
	*margin-left:-3px;
	*margin-top:1px;
}

.WL_MAC_Block{
	border:1px outset #999;
	background-color:#576D73;
	position:absolute;
	*margin-top:27px;	
	margin-left:231px;
	*margin-left:-133px;
	width:340px;
	text-align:left;	
	height:auto;
	overflow-y:auto;
	z-index:200;
	padding: 1px;
	display:none;
}
.WL_MAC_Block div{
	background-color:#576D73;
	height:auto;
	*height:20px;
	line-height:20px;
	text-decoration:none;
	font-family: Lucida Console;
	padding-left:2px;
}

.WL_MAC_Block a{
	background-color:#EFEFEF;
	color:#FFF;
	font-size:12px;
	font-family:Arial, Helvetica, sans-serif;
	text-decoration:none;	
}
.WL_MAC_Block div:hover, .WL_MAC_Block a:hover{
	background-color:#3366FF;
	color:#FFFFFF;
	cursor:default;
}	
</style>
<script>
var $j = jQuery.noConflict();

wan_route_x = '';
wan_nat_x = '1';

function login_ip_str() { return '<% tcWebApi_get("WebCurSet_Entry","login_ip_tmp","s"); %>'; }

function login_mac_str() { return ''; }


var wireless = []; // [[MAC, associated, authorized], ...]
var client_mac = login_mac_str();
var wl_macnum_x = '';
var smac = client_mac.split(":");
var simply_client_mac = smac[0] + smac[1] + smac[2] + smac[3] + smac[4] + smac[5];
var wl_maclist_x_array = '<% tcWebApi_get("ACL_Entry","wl_maclist","s"); %>';
function initial(){
	show_menu();
	autoFocus('<% get_parameter("af"); %>');
	if(sw_mode == 2 && '<% tcWebApi_get("WLan_Common","wl_unit","s"); %>' == ''){
		for(var i=3; i>=3; i--)
		$("MainTable1").deleteRow(i);
		for(var i=2; i>=0; i--)
		$("MainTable2").deleteRow(i);
		$("repeaterModeHint").style.display = "";
		$("wl_maclist_x_Block").style.display = "none";
		$("submitBtn").style.display = "none";
	}
	else
		show_wl_maclist_x(); 

	showWLMACList();
	if(!wl_info.band5g_support)
		$("wl_unit_field").style.display = "none";
}
function show_wl_maclist_x(){
	var wl_maclist_x_row = wl_maclist_x_array.split('<');
	var code = "";
	code +='<table width="100%" border="1" cellspacing="0" cellpadding="4" align="center" class="list_table" id="wl_maclist_x_table">';
	if(wl_maclist_x_row.length == 1)
		code +='<tr><td style="color:#FFCC00;"><%tcWebApi_get("String_Entry","IPC_VSList_Norule","s")%></td>';
	else{
		for(var i = 1; i < wl_maclist_x_row.length; i++){
			code +='<tr id="row'+i+'">';
			code +='<td width="80%">'+ wl_maclist_x_row[i] +'</td>';
			code +='<td width="20%"><input type="button" class=\"remove_btn\" onclick=\"deleteRow(this);\" value=\"\"/></td></tr>';
		}
	}
	code +='</tr></table>';
	$("wl_maclist_x_Block").innerHTML = code;
}
function deleteRow(r){
	var i=r.parentNode.parentNode.rowIndex;
	$('wl_maclist_x_table').deleteRow(i);
	var wl_maclist_x_value = "";
	for(i=0; i<$('wl_maclist_x_table').rows.length; i++){
		wl_maclist_x_value += "<";
		wl_maclist_x_value += $('wl_maclist_x_table').rows[i].cells[0].innerHTML;
	}
	wl_maclist_x_array = wl_maclist_x_value;
	if(wl_maclist_x_array == "")
		show_wl_maclist_x();
}
function addRow(obj, upper){
	var rule_num = $('wl_maclist_x_table').rows.length;
	var item_num = $('wl_maclist_x_table').rows[0].cells.length;
	if(rule_num >= upper){
		alert("<%tcWebApi_get("String_Entry","JS_itemlimit1","s")%> " + upper + " <%tcWebApi_get("String_Entry","JS_itemlimit2","s")%>");
		return false;
	}

	if(obj.value==""){
		alert("<%tcWebApi_get("String_Entry","JS_fieldblank","s")%>");
		obj.focus();
		obj.select();
		return false;
	}else if(!check_macaddr(obj, check_hwaddr_flag(obj))){
		obj.focus();
		obj.select();	
		return false;	
	}

	//Viz check same rule
		for(i=0; i<rule_num; i++){
			for(j=0; j<item_num-1; j++){
				if(obj.value.toLowerCase() == $('wl_maclist_x_table').rows[i].cells[j].innerHTML.toLowerCase()){
					alert("<%tcWebApi_get("String_Entry","JS_duplicate","s")%>");
					return false;
				}
			}
		}
		wl_maclist_x_array += "<"
		wl_maclist_x_array += obj.value;
		obj.value = ""
		show_wl_maclist_x();
}
function applyRule(){
	var rule_num = $('wl_maclist_x_table').rows.length;
	var item_num = $('wl_maclist_x_table').rows[0].cells.length;
	var tmp_value = "";
	for(i=0; i<rule_num; i++){
		tmp_value += "<"
		for(j=0; j<item_num-1; j++){
		tmp_value += $('wl_maclist_x_table').rows[i].cells[j].innerHTML;
		if(j != item_num-2)
		tmp_value += ">";
		}
	}
	if(tmp_value == "<"+"<%tcWebApi_get("String_Entry","IPC_VSList_Norule","s")%>" || tmp_value == "<")
	tmp_value = "";
	if(prevent_lock(tmp_value)){
		document.form.wl_maclist_x.value = tmp_value;
		document.form.action = "/cgi-bin/Advanced_ACL_Content.asp";
		document.form.editFlag.value = "1" ;
		if(model_name == "DSL-N66U")
		{
			showLoading(28);
			setTimeout("redirect();", 28000);
		}
		else
		{
			showLoading(23);
			setTimeout("redirect();", 23000);
		}
		if(navigator.appName.indexOf("Microsoft") >= 0){ 		// Jieming added at 2013/05/21, to avoid browser freeze when submitting form on IE
			stopFlag = 1;
		}
		document.form.submit();
	}
}
function done_validating(action){
refreshpage();
}
function prevent_lock(rule_num){
	if(document.form.wl_macmode.value == "allow" && rule_num == ""){
		alert("<%tcWebApi_get("String_Entry","FC_MFList_accept_hint1","s")%>");
		return false;
	}
	else
		return true;
}

function redirect(){
	document.location.href = "/cgi-bin/Advanced_ACL_Content.asp";
}

function _change_wl_unit(wl_unit){
	document.form_band.wl_unit.value = wl_unit;
	document.form_band.action = "/cgi-bin/Advanced_ACL_Content.asp";
	showLoading(2);
	setTimeout("redirect();", 2000);	
	document.form_band.submit();
}

//control hint of input mac address, Viz add 2013.07 
function check_macaddr(obj,flag){ 
	if(flag == 1){
var childsel=document.createElement("div");
childsel.setAttribute("id","check_mac");
childsel.style.color="#FFCC00";
obj.parentNode.appendChild(childsel);
		$("check_mac").innerHTML="<%tcWebApi_get("String_Entry","LHC_MnlDHCPMacaddr_id","s")%>";
		$("check_mac").style.display = "";
		return false;
	}else if(flag ==2){
		var childsel=document.createElement("div");
		childsel.setAttribute("id","check_mac");
		childsel.style.color="#FFCC00";
		obj.parentNode.appendChild(childsel);
		$("check_mac").innerHTML="<%tcWebApi_get("String_Entry","IPC_x_illegal_mac","s")%>";
		$("check_mac").style.display = "";
		return false;		
	}else{	
		$("check_mac") ? $("check_mac").style.display="none" : true;
		return true;
}
}

//Viz add 2013.01 pull out WL client mac START
function pullWLMACList(obj){	
	if(isMenuopen == 0){		
		obj.src = "/images/arrow-top.gif"
		document.getElementById("WL_MAC_List_Block").style.display = "block";
		document.form.wl_maclist_x_0.focus();		
		isMenuopen = 1;
	}
	else
		hideClients_Block();
}

var over_var = 0;
var isMenuopen = 0;

function hideClients_Block(){
	document.getElementById("pull_arrow").src = "/images/arrow-down.gif";
	document.getElementById("WL_MAC_List_Block").style.display="none";
	isMenuopen = 0;
}

function showWLMACList(){
	if(clientList.length == 0){
		setTimeout(function() {
			genClientList();
			showWLMACList();
		}, 500);
		return false;
	}
	
	var code = "";
	var show_macaddr = "";
	var wireless_flag = 0;
	for(i=0;i<clientList.length;i++){
		if(clientList[clientList[i]].isWL != 0 && (clientList[clientList[i]].isWL == (parseInt('<% tcWebApi_get("WLan_Common","wl_unit","s"); %>')+1))){		//0: wired, 1: 2.4GHz, 2: 5GHz, filter clients under current band
			wireless_flag = 1;
			
			if(clientList[clientList[i]].Name.length > 30) clientList[clientList[i]].Name = clientList[clientList[i]].Name.substring(0, 27) + "...";
			
			code += '<a><div onmouseover="over_var=1;" onmouseout="over_var=0;" onclick="setClientmac(\'';
			code += clientList[i];
			code += '\');"><strong>'+clientList[clientList[i]].Name+'</strong> ( '+clientList[i]+' )';
			code += ' </div></a>';
		}
	}
			
	code +='<!--[if lte IE 6.5]><iframe class="hackiframe2"></iframe><![endif]-->';	
	document.getElementById("WL_MAC_List_Block").innerHTML = code;
	
	if(wireless_flag == 0)
		document.getElementById("pull_arrow").style.display = "none";
	else
		document.getElementById("pull_arrow").style.display = "";
}

function setClientmac(macaddr){
	document.form.wl_maclist_x_0.value = macaddr;
	hideClients_Block();
	over_var = 0;
}
//Viz add 2013.01 pull out WL client mac END
</script>
</head>
<body onload="initial();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<form method="post" name="form_band" action="Advanced_ACL_Content.asp" target="hidden_frame">
<input type="hidden" name="wl_unit">
<input type="hidden" name="editFlag" value="0">
</form>
<form method="post" name="form" id="ruleForm" action="Advanced_ACL_Content.asp" target="hidden_frame">
<table class="content" align="center" cellpadding="0" cellspacing="0">
<tr>
<td width="17">&nbsp;</td>
<td valign="top" width="202">
<div id="mainMenu"></div>
<div id="subMenu"></div>
</td>
<td valign="top">
<div id="tabMenu" class="submenuBlock"></div>
<input type="hidden" name="current_page" value="Advanced_ACL_Content.asp">
<input type="hidden" name="next_page" value="Advanced_ACL_Content.asp">
<input type="hidden" name="next_host" value="">
<input type="hidden" name="modified" value="0">
<input type="hidden" name="action_mode" value="apply">
<input type="hidden" name="action_wait" value="3">
<input type="hidden" name="action_script" value="restart_wireless">
<input type="hidden" name="first_time" value="">
<input type="hidden" name="preferred_lang" id="preferred_lang" value="EN">
<input type="hidden" name="firmver" value="<% tcWebApi_staticGet("DeviceInfo","FwVer","s") %>">
<input type="hidden" name="wl_ssid" value="IBIZA_2.4G">
<input type="hidden" name="wl_maclist_x" value="">
<input type="hidden" name="wl_subunit" value="-1">
<input type="hidden" name="editFlag" value="0">
<input type="hidden" name="MBSSID_changeFlag" value="0">
<input type="hidden" name="MBSSID_able_Flag" value="0">
<input type="hidden" name="w_Setting" value="1">
<table width="98%" border="0" align="left" cellpadding="0" cellspacing="0">
<tr>
<td valign="top" >
<table width="760px" border="0" cellpadding="4" cellspacing="0" class="FormTitle" id="FormTitle">
<tbody>
<tr>
<td bgcolor="#4D595D" valign="top">
<div>&nbsp;</div>
		  <div class="formfonttitle"><%tcWebApi_get("String_Entry","menu5_1","s")%> - <%tcWebApi_get("String_Entry","menu5_1_4","s")%></div>
<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
		  <div class="formfontdesc"><%tcWebApi_get("String_Entry","DeviceSecurity11a_display1_sd","s")%></div>
<table id="MainTable1" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
	<thead>
	<tr>
				<td colspan="2"><%tcWebApi_get("String_Entry","t2BC","s")%></td>
	</tr>
	</thead>
	<tr id="wl_unit_field">
				<th><%tcWebApi_get("String_Entry","Interface","s")%></th>
		<td>
			<select name="wl_unit" class="input_option" onChange="_change_wl_unit(this.value);">
				<option class="content_input_fd" value="0" <% if tcWebApi_get("WLan_Common","wl_unit","h") = "0" then asp_Write("selected") end if %>>2.4GHz</option>
				<option class="content_input_fd" value="1" <% if tcWebApi_get("WLan_Common","wl_unit","h") = "1" then asp_Write("selected") end if %>>5GHz</option>
			</select>
		</td>
	</tr>
	<tr id="repeaterModeHint" style="display:none;">
				<td colspan="2" style="color:#FFCC00;height:30px;" align="center"><%tcWebApi_get("String_Entry","page_not_support_mode_hint","s")%></td>
	</tr>
	<tr>
		<th width="30%" >
					<a class="hintstyle" href="javascript:void(0);" onClick="openHint(18,1);"><%tcWebApi_get("String_Entry","FC_MFMethod_in","s")%></a>
		</th>
		<td>
			<select name="wl_macmode" class="input_option" onChange="return change_common(this, 'DeviceSecurity11a', 'wl_macmode')">
				<option class="content_input_fd" value="disabled" <% if tcWebApi_get("ACL_Entry","wl_macmode","h") = "disabled" then asp_Write("selected") end if %>><%tcWebApi_get("String_Entry","CTL_Disabled","s")%></option>
				<option class="content_input_fd" value="allow" <% if tcWebApi_get("ACL_Entry","wl_macmode","h") = "allow" then asp_Write("selected") end if %>><%tcWebApi_get("String_Entry","FC_MFMethod_item1","s")%></option>
				<option class="content_input_fd" value="deny" <% if tcWebApi_get("ACL_Entry","wl_macmode","h") = "deny" then asp_Write("selected") end if %>><%tcWebApi_get("String_Entry","FC_MFMethod_item2","s")%></option>
			</select>
		</td>
	</tr>
</table>
<table id="MainTable2" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable_table">
	<thead>
	<tr>
				<td colspan="2"><%tcWebApi_get("String_Entry","FC_MFList_groupitemname","s")%> (<%tcWebApi_get("String_Entry","List_limit","s")%> 31)</td>
	</tr>
	</thead>
	<tr>
	<th width="80%"><a class="hintstyle" href="javascript:void(0);" onClick="openHint(5,10);">
									<%tcWebApi_get("String_Entry","FC_MFList_groupitemname","s")%>
	</th>
	<th width="20%"><% tcWebApi_Get("String_Entry", "list_add_delete", "s") %></th>
	</tr>
	<tr>
	<td width="80%">
		<input type="text" maxlength="17" class="input_macaddr_table" name="wl_maclist_x_0" onKeyPress="return validator.isHWAddr(this,event)" onClick="hideClients_Block();">
		<img id="pull_arrow" height="14px;" src="/images/arrow-down.gif" style="position:absolute;display:none;" onclick="pullWLMACList(this);" title="<% tcWebApi_Get("String_Entry", "select_wireless_MAC", "s") %>" onmouseover="over_var=1;" onmouseout="over_var=0;">
		<div id="WL_MAC_List_Block" class="WL_MAC_Block"></div>
	</td>
	<td width="20%">
	<input type="button" class="add_btn" onClick="addRow(document.form.wl_maclist_x_0, 31);" value="">
	</td>
	</tr>
</table>
<div id="wl_maclist_x_Block"></div>
<div id="submitBtn" class="apply_gen">
				<input class="button_gen" onclick="applyRule()" type="button" value="<%tcWebApi_get("String_Entry","CTL_apply","s")%>"/>
</div>
</td>
</tr>
</tbody>
</table>
</td>
</form>
</tr>
</table>
</td>
<td width="10" align="center" valign="top">&nbsp;</td>
</tr>
</table>
<div id="footer"></div>
</body>

<!--Advanced_ACL_Content.asp-->
</html>


