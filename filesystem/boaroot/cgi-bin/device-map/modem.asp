<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<!--device-map/modem.asp-->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<link rel="shortcut icon" href="/images/favicon.png">
<link rel="icon" href="/images/favicon.png">
<title></title>
<link href="/NM_style.css" rel="stylesheet" type="text/css" />
<link href="/form_style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/state.js"></script>
<script>
var dongle_name;
if(parent.get_clicked_device_order())
	dongle_name = parent.usb_path1_product;
else
	dongle_name = parent.usb_path0_product;
function initial(){
	showtext($("disk_model_name"), dongle_name);
}
function goHspdaWizard(){
	parent.location.href = "/cgi-bin/Advanced_Modem_Content.asp";
}
function remove_d3g(){
	var str = "Do you really want to remove this USB dongle?";
	if(confirm(str)){
		parent.showLoading();
		document.diskForm.action = "safely_remove_disk.asp";
		setTimeout("document.diskForm.submit();", 8000);
	}
}
</script>
</head>
<body class="statusbody" onload="initial();">
<table width="95%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="table1px">
	<tr>
		<td style="padding:5px 10px 0px 15px;">
    	<p class="formfonttitle_nwm"><%tcWebApi_get("String_Entry","Modelname","s")%>:</p>
			<p style="padding-left:10px; margin-top:3px; background-color:#444f53; line-height:20px; color:#FFFFFF;" id="disk_model_name"></p>
			<img style="margin-top:5px;" src="/images/New_ui/networkmap/linetwo2.png">
		</td>
	</tr>
	<tr>
		<td height="50" style="padding:10px 15px 0px 15px;">
    	<p class="formfonttitle_nwm" style="float:left;width:138px;"><%tcWebApi_get("String_Entry","GO_HSDPA_SETTING","s")%></p>
    	<input type="button" class="button_gen" onclick="goHspdaWizard();" value="<%tcWebApi_get("String_Entry","btn_go","s")%>">
			<img style="margin-top:5px;" src="/images/New_ui/networkmap/linetwo2.png">
		</td>
	</tr>
	<!--tr>
	<td height="50" style="padding:10px 15px 0px 15px;">
    	<p class="formfonttitle_nwm" style="float:left;width:138px; "><%tcWebApi_get("String_Entry","Safelyremovedisk_title","s")%>:</p>
    	<input id="show_remove_button" class="button_gen" type="button" class="button" onclick="remove_d3g();" value="<%tcWebApi_get("String_Entry","btn_remove","s")%>">
    	<div id="show_removed_string" style="display:none;"><%tcWebApi_get("String_Entry","Safelyremovedisk","s")%></div>
	</td>
	</tr-->
</table>
<form method="post" name="diskForm" action="#">
<input type="hidden" name="disk" value="">
</form>
</body>

<!--device-map/modem.asp-->
</html>

