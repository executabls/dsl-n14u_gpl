<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<html xmlns:v>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<link rel="shortcut icon" href="/images/favicon.png">
<link rel="icon" href="/images/favicon.png">
<title>ASUS <% tcWebApi_Get("String_Entry","Web_Title2","s") %> <% tcWebApi_Get("SysInfo_Entry","ProductTitle","s") %> - <%tcWebApi_Get("String_Entry", "AiCloud_Title","s")%></title>
<link rel="stylesheet" type="text/css" href="/index_style.css"> 
<link rel="stylesheet" type="text/css" href="/form_style.css">
<script language="JavaScript" type="text/javascript" src="/md5.js"></script>
<script language="JavaScript" type="text/javascript" src="/state.js"></script>
<script language="JavaScript" type="text/javascript" src="/popup.js"></script>
<script language="JavaScript" type="text/javascript" src="/help.js"></script>
<script language="JavaScript" type="text/javascript" src="/detect.js"></script>
<script language="JavaScript" type="text/javascript" src="/general.js"></script>
<script language="JavaScript" type="text/javascript" src="/jquery.js"></script>
<script language="JavaScript" type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script language="JavaScript" type="text/javascript" src="/disk_functions.js"></script>
<script language="JavaScript" type="text/javascript" src="/md5.js"></script>
<script language="JavaScript" type="text/javascript" src="/validator.js"></script>
<style type="text/css">
/* folder tree */
.mask_bg{
	position:absolute;	
	margin:auto;
	top:0;
	left:0;
	width:100%;
	height:100%;
	z-index:100;
	background:url(/images/popup_bg2.gif);
	background-repeat: repeat;
	filter:progid:DXImageTransform.Microsoft.Alpha(opacity=60);
	-moz-opacity: 0.6;
	display:none;
	overflow:hidden;
}
.mask_floder_bg{
	position:absolute;	
	margin:auto;
	top:0;
	left:0;
	width:100%;
	height:100%;
	z-index:300;
	background:url(/images/popup_bg2.gif);
	background-repeat: repeat;
	filter:progid:DXImageTransform.Microsoft.Alpha(opacity=60);
	-moz-opacity: 0.6;
	display:none;
	overflow:hidden;
}
.folderClicked{
	color:#569AC7;
	font-size:14px;
	cursor:pointer;
}
.lastfolderClicked{
	color:#FFFFFF;
	cursor:pointer;
}
#status_gif_Img_L{
	background-image:url(/images/cloudsync/left_right_trans.gif);
	background-position: 10px -0px; width: 59px; height: 38px;
}
#status_gif_Img_LR{
	background-image:url(/images/cloudsync/left_right_trans.gif);
	background-position: 10px -47px; width: 59px; height: 38px;
}
#status_gif_Img_R{
	background-image:url(/images/cloudsync/left_right_trans.gif);
	background-position: 10px -97px; width: 59px; height: 38px;
}

#status_png_Img_error{
	background-image:url(/images/cloudsync/left_right_done.png);
	background-position: -0px -0px; width: 59px; height: 38px;
}
#status_png_Img_L_ok{
	background-image:url(/images/cloudsync/left_right_done.png);
	background-position: -0px -47px; width: 59px; height: 38px;
}
#status_png_Img_R_ok{
	background-image:url(/images/cloudsync/left_right_done.png);
	background-position: -0px -95px; width: 59px; height: 38px;
}
#status_png_Img_LR_ok{
	background-image:url(/images/cloudsync/left_right_done.png);
	background-position: -0px -142px; width: 59px; height: 38px;
}

.invitation_head{
background: url(/images/New_ui/title_bg.png) 0 0 no-repeat;
background-size: 100% 100%; 

}
.invitation_body{
background: url(/images/New_ui/midup_bg.png) 0 0 no-repeat;
background-size: 100% 100%; 
height:260px;

filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(
src='/images/New_ui/midup_bg.png',
sizingMethod='scale');

-ms-filter: "progid:DXImageTransform.Microsoft.AlphaImageLoader(
src='/images/New_ui/midup_bg.png',
sizingMethod='scale')";

}
.invitation_foot{
background: url(/images/New_ui/bottom_bg.png) 0 0 no-repeat;
background-size: 100% 100%; 

}
</style>
<script>
var $j = jQuery.noConflict();
<% wanlink(); %>
<% login_state_hook(); %>
<% get_AiDisk_status(); %>
<% disk_pool_mapping_info(); %>
//var wireless = [];	// [[MAC, associated, authorized], ...]
//wan_route_x = '';
//wan_nat_x = '';
//wan_proto = '';


var cloud_status = "";
var cloud_obj = "";
var cloud_msg = "";
var curRule = -1;
<% UI_cloud_status(); %>
var cloud_sync = '<% tcWebApi_Get("AiCloud_Entry","share_link_host","s") %>';
/* type>user>password>url>rule>dir><%tcWebApi_get("String_Entry","WC11b_WirelessCtrl_button1name","s")%> */
var cloud_synclist_array = cloud_sync.replace(/>/g, "&#62").replace(/</g, "&#60"); 
var cloud_synclist_all = new Array(); 
var isEdit = 0;

var maxrulenum = 1;
var rulenum = 1;
var disk_flag=0;
var FromObject = "0";
var lastClickedObj = 0;
var _layer_order = "";
var isNotIE = (navigator.userAgent.search("MSIE") == -1); 
var PROTOCOL = "cifs";
//window.onresize = cal_panel_block;
var router_sync = '<% tcWebApi_Get("AiCloud_Entry","share_link_host","s") %>';
var router_synclist = '';
var router_synclist_type = new Array();
var router_synclist_desc = new Array();
var router_synclist_sharelink = new Array();
var router_synclist_rule = new Array();
var router_synclist_captcha = new Array();
var router_synclist_localfolder = new Array();
var router_synclist_array = router_sync.replace(/>/g, "&#62").replace(/</g, "&#60");
var based_modelid = '<% ej_get_productid() %>';
var invitation_flag = 0;
var ip_flag = 0;  // 0: public, 1: private
var ddns_enable = '<% if tcWebApi_Get("Ddns_Entry","Active","s") = "1" then asp_write("1") else asp_write("0") end if%>';
var ddns_host_name = '<% tcWebApi_Get("Ddns_Entry","MYHOST","s") %>';
var macAddr = '<% tcWebApi_Get("Info_Ether","mac","s") %>';
var host_macaddr = macAddr.split(':');
var isMD5DDNSName = "A"+hexMD5(macAddr).toUpperCase()+".asuscomm.com";
var webdav_aidisk = '<% tcWebApi_Get("AiCloud_Entry","webdav_aidisk","s") %>';
var webdav_proxy = '<% tcWebApi_Get("AiCloud_Entry","webdav_proxy","s") %>';
	
	
function initial(){
	check_aicloud();
	decode_router_synclist();
	show_menu();
	showAddTable();
	showcloud_synclist();
	document.aidiskForm.protocol.value = PROTOCOL;
	initial_dir();
	valid_wan_ip();
}

function initial_dir(){
	var __layer_order = "0_0";
	var url = "/cgi-bin/getfoldertree.asp";
	var type = "General";

	url += "?motion=gettree&layer_order=" + __layer_order + "&t=" + Math.random();
	$j.get(url,function(data){initial_dir_status(data);});
}

function initial_dir_status(data){
	if(data == ""){	
		$("noUSB").style.display = "";
		disk_flag=1;
	}
}

function addRow(obj, head){
	if(head == 1)
		cloud_synclist_array += "&#62";
	else
		cloud_synclist_array += "&#60";
			
	cloud_synclist_array += obj.value;
	obj.value = "";
}

function addRow_Group(upper){ 
	var rule_num = $('cloud_synclist_table').rows.length;
	var item_num = $('cloud_synclist_table').rows[0].cells.length;
	
	if(rule_num >= upper){
		alert("<% tcWebApi_Get("String_Entry", "JS_itemlimit1", "s") %> " + upper + "<% tcWebApi_Get("String_Entry", "JS_itemlimit2", "s") %>");
		return false;	
	}							
	Do_addRow_Group();		
}

function Do_addRow_Group(){		
	addRow(document.form.cloud_sync_type ,1);
	addRow(document.form.cloud_sync_username, 0);
	addRow(document.form.cloud_sync_password, 0);
	addRow(document.form.cloud_sync_dir, 0);
	addRow(document.form.cloud_sync_rule, 0);
	showcloud_synclist();
}

function edit_Row(r){ 	
	document.form.cloud_username.value = cloud_synclist_all[r][1];
	document.form.cloud_password.value = cloud_synclist_all[r][2];
	document.form.cloud_dir.value = cloud_synclist_all[r][5].substring(4);
	document.form.cloud_rule.value = cloud_synclist_all[r][4];
}

function del_Row(r){
	var router_synclist_row = router_synclist_array.split('&#60'); // resample
	var i=r.parentNode.parentNode.rowIndex;
	var router_synclist_value = "";

	for(k=0; k<router_synclist_row.length; k++){
		if(k == i)
			continue;
		else
			router_synclist_value += "&#60";

		var router_synclist_col = router_synclist_row[k].split('&#62');
		for(j=0; j< router_synclist_col.length; j++){
			router_synclist_value += router_synclist_col[j];
			if(j !=  router_synclist_col.length-1)
				router_synclist_value += "&#62";
		}
	}

	router_synclist_array = router_synclist_value;
	showcloud_synclist();
	document.sharelink_form.share_link_host.value = router_synclist_array.replace(/&#62/g, ">").replace(/&#60/g, "<");
	document.sharelink_form.share_link_host.value = document.sharelink_form.share_link_host.value.substr(1);
	var url_deleted = router_synclist_row[i].split('&#62');
	var url_http_split = url_deleted[2].split('//');
	var sharelink_deteted = url_http_split[1].split('/');	
	document.sharelink_form.share_link_param.value = "delete>" + sharelink_deteted[1];
	showLoading(2);
	document.sharelink_form.submit();
	setTimeout('refreshpage()',3000);
}

function showcloud_synclist(){
	rulenum = 0;
	var cloud_synclist_row = cloud_synclist_array.split('&#60');
	var code = "";

	code +='<table width="99%" cellspacing="0" cellpadding="4" align="center" class="list_table" id="cloud_synclist_table">';
	if(cloud_synclist_array == "")
		code +='<tr height="55px"><td style="color:#FFCC00;" colspan="6"><% tcWebApi_Get("String_Entry", "IPC_VSList_Norule", "s") %></td>';
	else{
		for(var i = 0; i < cloud_synclist_row.length; i++){
			rulenum++;
			code +='<tr id="row'+i+'" height="55px">';
			var cloud_synclist_col = cloud_synclist_row[i].split('&#62');
			
			cloud_synclist_all[i] = cloud_synclist_col;
			var wid = [10, 25,0,10,0,30,25];
			for(var j = 0; j < cloud_synclist_col.length; j++){
				if(j == 2 || j== 4){
					continue;
				}
				else{
					if(j == 0)
						code +='<td width="'+wid[j]+'%"><span style="display:none">'+ cloud_synclist_col[j] +'</span><img width="30px" src="/images/cloudsync/rssync.png"></td>';
					else if(j == 1)
						code +='<td width="'+wid[j]+'%"><span style="display:none">'+ cloud_synclist_col[j] +'</span><span style="font-size:16px;font-family: Calibri;font-weight: bolder;"  onclick="isEdit=1;showAddTable();">'+ cloud_synclist_col[j] +'</span></td>';
					else if(j == 3){
						curRule = cloud_synclist_col[j];
						if(cloud_synclist_col[j] == 2)
							code +='<td width="'+wid[j]+'%"><span style="display:none">'+ cloud_synclist_col[j] +'</span><div id="status_image"><div id="status_png_Img_R_ok"></div></div></td>';//code +='<td width="'+wid[j]+'%"><span style="display:none">'+ cloud_synclist_col[j] +'</span><img id="statusImg" width="45px" src="/images/cloudsync/left.gif"></td>';
						else if(cloud_synclist_col[j] == 1)
							code +='<td width="'+wid[j]+'%"><span style="display:none">'+ cloud_synclist_col[j] +'</span><div id="status_image"><div id="status_png_Img_L_ok"></div></div></td>';
						else
							code +='<td width="'+wid[j]+'%"><span style="display:none">'+ cloud_synclist_col[j] +'</span><div id="status_image"><div id="status_png_Img_LR_ok"></div></div></td>';
					}
					else{
						code +='<td width="'+wid[j]+'%"><span style="display:none;">'+ cloud_synclist_col[j] +'</span><span style="word-break:break-all;">'+ cloud_synclist_col[j].substr(4, cloud_synclist_col[j].length) +'</span></td>';
					}
				}
			}
			code +='<td width="15%"><span style="text-decoration:underline;cursor:pointer;font-weight: bolder;" onclick="show_view_info(this.parentNode.parentNode.id);">View</span></td>';
			code +='<td width="10%"><input class="remove_btn" onclick="del_Row(this);" value=""/></td>';	
		}
	}
	code +='</table>';
	$("cloud_synclist_Block").innerHTML = code;
}

function validform(){
	if(!Block_chars(document.form.cloud_username, ["<", ">"]))
		return false;

	if(document.form.cloud_username.value == ''){
		alert("<% tcWebApi_Get("String_Entry", "File_Pop_content_alert_desc1", "s") %>");
		return false;
	}

	if(!Block_chars(document.form.cloud_password, ["<", ">"]))
		return false;

	if(document.form.cloud_password.value == ''){
		alert("<% tcWebApi_Get("String_Entry", "File_Pop_content_alert_desc6", "s") %>");
		return false;
	}

	if(document.form.cloud_dir.value.split("/").length < 4 || document.form.cloud_dir.value == ''){
		alert("<% tcWebApi_Get("String_Entry", "ALERT_OF_ERROR_Input10", "s") %>");
		return false;
	}
	return true;
}

function showAddTable(){
	if(isEdit == 1){ // edit
		//$j("#cloudAddTable").fadeIn();
		//$("creatBtn").style.display = "none";
		//$j("#applyBtn").fadeIn();
		if(cloud_synclist_array != ""){
			edit_Row(0);
		}
	}
	else{ // list
		//$("cloudAddTable").style.display = "none";
		if(cloud_synclist_array == ""){
			//$j("#creatBtn").fadeIn();
			//$("applyBtn").style.display = "none";
		}
		else{
			//$("creatBtn").style.display = "none";
			//$("applyBtn").style.display = "none";			
		}
	}
}

// get folder tree
var folderlist = new Array();
function get_disk_tree(){
	if(disk_flag == 1){
		alert('<% tcWebApi_Get("String_Entry", "no_usb_found", "s") %>');
		return false;	
	}
	cal_panel_block('folderTree_panel');
	$j("#folderTree_panel").fadeIn(300);
	get_layer_items("0");
}
function get_layer_items(layer_order){
	$j.ajax({
    		url: '/cgi-bin/gettree.asp?layer_order='+layer_order,
    		dataType: 'script',
    		error: function(xhr){
    			;
    		},
    		success: function(){
				get_tree_items(treeitems);					
  			}
		});
}
function get_tree_items(treeitems){
	document.aidiskForm.test_flag.value = 0;
	this.isLoading = 1;
	var array_temp = new Array();
	var array_temp_split = new Array();
	for(var j=0;j<treeitems.length;j++){ // To hide folder 'Download2' & 'asusware'
		array_temp_split[j] = treeitems[j].split("#");
		if( array_temp_split[j][0].match(/^Download2$/) || array_temp_split[j][0].match(/^asusware$/)	){
			continue;					
		}
		
		array_temp.push(treeitems[j]);
	}
	this.Items = array_temp;
	if(this.Items && this.Items.length >= 0){
		BuildTree();
	}	
}
function BuildTree(){
	var ItemText, ItemSub, ItemIcon;
	var vertline, isSubTree;
	var layer;
	var short_ItemText = "";
	var shown_ItemText = "";
	var ItemBarCode ="";
	var TempObject = "";

	for(var i = 0; i < this.Items.length; ++i){
		this.Items[i] = this.Items[i].split("#");
		var Item_size = 0;
		Item_size = this.Items[i].length;
		if(Item_size > 3){
			var temp_array = new Array(3);	
			
			temp_array[2] = this.Items[i][Item_size-1];
			temp_array[1] = this.Items[i][Item_size-2];			
			temp_array[0] = "";
			for(var j = 0; j < Item_size-2; ++j){
				if(j != 0)
					temp_array[0] += "#";
				temp_array[0] += this.Items[i][j];
			}
			this.Items[i] = temp_array;
		}	
		ItemText = (this.Items[i][0]).replace(/^[\s]+/gi,"").replace(/[\s]+$/gi,"");
		ItemBarCode = this.FromObject+"_"+(this.Items[i][1]).replace(/^[\s]+/gi,"").replace(/[\s]+$/gi,"");
		ItemSub = parseInt((this.Items[i][2]).replace(/^[\s]+/gi,"").replace(/[\s]+$/gi,""));
		layer = get_layer(ItemBarCode.substring(1));
		if(layer == 3){
			if(ItemText.length > 21)
		 		short_ItemText = ItemText.substring(0,18)+"...";
		 	else
		 		short_ItemText = ItemText;
		}
		else
			short_ItemText = ItemText;
		
		shown_ItemText = showhtmlspace(short_ItemText);
		
		if(layer == 1)
			ItemIcon = 'disk';
		else if(layer == 2)
			ItemIcon = 'part';
		else
			ItemIcon = 'folders';
		
		SubClick = ' onclick="GetFolderItem(this, ';
		if(ItemSub <= 0){
			SubClick += '0);"';
			isSubTree = 'n';
		}
		else{
			SubClick += '1);"';
			isSubTree = 's';
		}
		
		if(i == this.Items.length-1){
			vertline = '';
			isSubTree += '1';
		}
		else{
			vertline = ' background="/images/Tree/vert_line.gif"';
			isSubTree += '0';
		}
		
		if(layer == 2 && isSubTree == 'n1'){	// Uee to rebuild folder tree if disk without folder, Jieming add at 2012/08/29
			document.aidiskForm.test_flag.value = 1;			
		}
		
		TempObject +='<table class="tree_table" id="bug_test">';
		TempObject +='<tr>';
		// the line in the front.
		TempObject +='<td class="vert_line">';
		TempObject +='<img id="a'+ItemBarCode+'" onclick=\'$("d'+ItemBarCode+'").onclick();\' class="FdRead" src="/images/Tree/vert_line_'+isSubTree+'0.gif">';
		TempObject +='</td>';
	
		if(layer == 3){
			/*a: connect_line b: harddisc+name  c:harddisc  d:name e: next layer forder*/
			TempObject +='<td>';		
			TempObject +='<img id="c'+ItemBarCode+'" onclick=\'$("d'+ItemBarCode+'").onclick();\' src="/images/New_ui/advancesetting/'+ItemIcon+'.png">';
			TempObject +='</td>';
			TempObject +='<td>';
			TempObject +='<span id="d'+ItemBarCode+'"'+SubClick+' title="'+ItemText+'">'+shown_ItemText+'</span>';
			TempObject +='</td>';
		}
		else if(layer == 2){
			TempObject +='<td>';
			TempObject +='<table class="tree_table">';
			TempObject +='<tr>';
			TempObject +='<td class="vert_line">';
			TempObject +='<img id="c'+ItemBarCode+'" onclick=\'$("d'+ItemBarCode+'").onclick();\' src="/images/New_ui/advancesetting/'+ItemIcon+'.png">';
			TempObject +='</td>';
			TempObject +='<td class="FdText">';
			TempObject +='<span id="d'+ItemBarCode+'"'+SubClick+' title="'+ItemText+'">'+shown_ItemText+'</span>';
			TempObject +='</td>\n';
			TempObject +='<td></td>';
			TempObject +='</tr>';
			TempObject +='</table>';
			TempObject +='</td>';
			TempObject +='</tr>';
			TempObject +='<tr><td></td>';
			TempObject +='<td colspan=2><div id="e'+ItemBarCode+'" ></div></td>';
		}
		else{
			/*a: connect_line b: harddisc+name  c:harddisc  d:name e: next layer forder*/
			TempObject +='<td>';
			TempObject +='<table><tr><td>';
			TempObject +='<img id="c'+ItemBarCode+'" onclick=\'$("d'+ItemBarCode+'").onclick();\' src="/images/New_ui/advancesetting/'+ItemIcon+'.png">';
			TempObject +='</td><td>';
			TempObject +='<span id="d'+ItemBarCode+'"'+SubClick+' title="'+ItemText+'">'+shown_ItemText+'</span>';
			TempObject +='</td></tr></table>';
			TempObject +='</td>';
			TempObject +='</tr>';
			TempObject +='<tr><td></td>';
			TempObject +='<td><div id="e'+ItemBarCode+'" ></div></td>';
		}
		TempObject +='</tr>';
	}
	TempObject +='</table>';
	$("e"+this.FromObject).innerHTML = TempObject;
}

function get_layer(barcode){
	var tmp, layer;
	layer = 0;
	while(barcode.indexOf('_') != -1){
		barcode = barcode.substring(barcode.indexOf('_'), barcode.length);
		++layer;
		barcode = barcode.substring(1);		
	}
	return layer;
}
function build_array(obj,layer){
	var path_temp ="/mnt";
	var layer2_path ="";
	var layer3_path ="";
	if(obj.id.length>6){
		if(layer ==3){
			//layer3_path = "/" + $(obj.id).innerHTML;
			layer3_path = "/" + obj.title;
			while(layer3_path.indexOf("&nbsp;") != -1)
				layer3_path = layer3_path.replace("&nbsp;"," ");
				
			if(obj.id.length >8)
				layer2_path = "/" + $(obj.id.substring(0,obj.id.length-3)).innerHTML;
			else
				layer2_path = "/" + $(obj.id.substring(0,obj.id.length-2)).innerHTML;
			
			while(layer2_path.indexOf("&nbsp;") != -1)
				layer2_path = layer2_path.replace("&nbsp;"," ");
		}
	}
	if(obj.id.length>4 && obj.id.length<=6){
		if(layer ==2){
			//layer2_path = "/" + $(obj.id).innerHTML;
			layer2_path = "/" + obj.title;
			while(layer2_path.indexOf("&nbsp;") != -1)
				layer2_path = layer2_path.replace("&nbsp;"," ");
		}
	}
	path_temp = path_temp + layer2_path +layer3_path;
	return path_temp;
}
function GetFolderItem(selectedObj, haveSubTree){
	var barcode, layer = 0;
	showClickedObj(selectedObj);
	barcode = selectedObj.id.substring(1);	
	layer = get_layer(barcode);
	
	if(layer == 0)
		alert("Machine: Wrong");
	else if(layer == 1){
		// chose Disk
		setSelectedDiskOrder(selectedObj.id);
		path_directory = build_array(selectedObj,layer);
		$('createFolderBtn').src = "/images/New_ui/advancesetting/FolderAdd.png";
		$('deleteFolderBtn').src = "/images/New_ui/advancesetting/FolderDel.png";
		$('modifyFolderBtn').src = "/images/New_ui/advancesetting/FolderMod.png";
		$('createFolderBtn').onclick = function(){};
		$('deleteFolderBtn').onclick = function(){};
		$('modifyFolderBtn').onclick = function(){};
	}
	else if(layer == 2){
		// chose Partition
		setSelectedPoolOrder(selectedObj.id);
		path_directory = build_array(selectedObj,layer);
		$('createFolderBtn').src = "/images/New_ui/advancesetting/FolderAdd_0.png";
		$('deleteFolderBtn').src = "/images/New_ui/advancesetting/FolderDel.png";
		$('modifyFolderBtn').src = "/images/New_ui/advancesetting/FolderMod.png";
		$('createFolderBtn').onclick = function(){popupWindow('OverlayMask','/cgi-bin/aidisk/popCreateFolder.asp');};		
		$('deleteFolderBtn').onclick = function(){};
		$('modifyFolderBtn').onclick = function(){};
		document.aidiskForm.layer_order.disabled = "disabled";
		document.aidiskForm.layer_order.value = barcode;
	}
	else if(layer == 3){
		// chose Shared-Folder
		setSelectedFolderOrder(selectedObj.id);
		path_directory = build_array(selectedObj,layer);
		$('createFolderBtn').src = "/images/New_ui/advancesetting/FolderAdd.png";
		$('deleteFolderBtn').src = "/images/New_ui/advancesetting/FolderDel_0.png";
		$('modifyFolderBtn').src = "/images/New_ui/advancesetting/FolderMod_0.png";
		$('createFolderBtn').onclick = function(){};		
		$('deleteFolderBtn').onclick = function(){popupWindow('OverlayMask','/cgi-bin/aidisk/popDeleteFolder.asp');};
		$('modifyFolderBtn').onclick = function(){popupWindow('OverlayMask','/cgi-bin/aidisk/popModifyFolder.asp');};
		document.aidiskForm.layer_order.disabled = "disabled";
		document.aidiskForm.layer_order.value = barcode;
	}

	if(haveSubTree)
		GetTree(barcode, 1);
}
function showClickedObj(clickedObj){
	if(this.lastClickedObj != 0)
		this.lastClickedObj.className = "lastfolderClicked";  //this className set in AiDisk_style.css
	
	clickedObj.className = "folderClicked";
	this.lastClickedObj = clickedObj;
}
function GetTree(layer_order, v){
	if(layer_order == "0"){
		this.FromObject = layer_order;
		$('d'+layer_order).innerHTML = '<span class="FdWait">. . . . . . . . . .</span>';
		setTimeout('get_layer_items("'+layer_order+'", "gettree")', 1);		
		return;
	}
	
	if($('a'+layer_order).className == "FdRead"){
		$('a'+layer_order).className = "FdOpen";
		$('a'+layer_order).src = "/images/Tree/vert_line_s"+v+"1.gif";		
		this.FromObject = layer_order;		
		$('e'+layer_order).innerHTML = '<img src="/images/Tree/folder_wait.gif">';
		setTimeout('get_layer_items("'+layer_order+'", "gettree")', 1);
	}
	else if($('a'+layer_order).className == "FdOpen"){
		$('a'+layer_order).className = "FdClose";
		$('a'+layer_order).src = "/images/Tree/vert_line_s"+v+"0.gif";		
		$('e'+layer_order).style.position = "absolute";
		$('e'+layer_order).style.visibility = "hidden";
	}
	else if($('a'+layer_order).className == "FdClose"){
		$('a'+layer_order).className = "FdOpen";
		$('a'+layer_order).src = "/images/Tree/vert_line_s"+v+"1.gif";		
		$('e'+layer_order).style.position = "";
		$('e'+layer_order).style.visibility = "";
	}
	else
		alert("Error when show the folder-tree!");
}

function cancel_folderTree(){
	this.FromObject ="0";
	$j("#folderTree_panel").fadeOut(300);
}

function confirm_folderTree(){
	$('PATH').value = path_directory ;
	this.FromObject ="0";
	$j("#folderTree_panel").fadeOut(300);
}

function cal_panel_block(obj_id){
	var blockmarginLeft;
	if (window.innerWidth)
		winWidth = window.innerWidth;
	else if ((document.body) && (document.body.clientWidth))
		winWidth = document.body.clientWidth;
		
	if (document.documentElement  && document.documentElement.clientHeight && document.documentElement.clientWidth){
		winWidth = document.documentElement.clientWidth;
	}

	if(winWidth >1050){	
		winPadding = (winWidth-1050)/2;	
		winWidth = 1105;
		blockmarginLeft= (winWidth*0.25)+winPadding;
	}
	else if(winWidth <=1050){
		blockmarginLeft= (winWidth)*0.25+document.body.scrollLeft;	

	}
	//$("folderTree_panel").style.marginLeft = blockmarginLeft+"px";
	$(obj_id).style.marginLeft = blockmarginLeft+"px";
}
function show_invitation(share_link_url){
	var invite_content = "";
	var sync_rule_desc = "";
	$('invite_desc').innerHTML = "Sync description: "+document.form.router_sync_desc.value;
	$('invite_path').innerHTML = document.form.cloud_dir.value;
	if(document.form.router_sync_rule.value == 0)
		sync_rule_desc = "Two way sync";
	else if(document.form.router_sync_rule.value == 1)
		sync_rule_desc = "Host to client";
	else
		sync_rule_desc = "Client to host";
		
	$('invite_rule').innerHTML = "Sync rule: "+sync_rule_desc;
	//$('invite_share').innerHTML = url_name + "/" +share_link_url;
	$('invite_share').innerHTML = "http://router.asus.com/" + share_link_url;
	$("mailto").innerHTML = appendMailTo();
	
	cal_panel_block('invitation_block');
}

function show_captcha_style(captcha){		// captcha display style
	if( $('captcha_rule').value == 2){  
		var graph_content = "";
		for(i=0;i<4;i++){
			graph_content += '<img style="height:30px;" src="/images/cloudsync/captcha/'+captcha[i]+'.jpg">';
		}
		$('invite_captcha').innerHTML = "<% tcWebApi_Get("String_Entry","routerSync_Security_code","s") %>: "+graph_content;
	}
	else if( $('captcha_rule').value == 0)
		$('invite_captcha').innerHTML = "<% tcWebApi_Get("String_Entry","routerSync_Security_code","s") %>: None";
	else
		$('invite_captcha').innerHTML = "<% tcWebApi_Get("String_Entry","routerSync_Security_code","s") %>: "+captcha;
}

function close_invitation_block(){	
	$j("#invitation_block").fadeOut(300);
	if(invitation_flag == 0)
		refreshpage();
		
	invitation_flag = 0;
}

function applyRule(sharelink){
		var router_sync_type = 1;
		var captcha = "";	
		var router_synclist_row = router_synclist.split("&#60");
		var url_name = "";
		var hash_url = "";
		var hashed_link = "";
		var temp = document.form.cloud_dir.value.split('/');
		var sharelink_folder = "";
		for(var i=1; i< temp.length;i++){		// To get share_link_result
			if( i == (temp.length-1) && temp.length != 1 ) 	
				sharelink_folder = temp[i];
		}
		
		if($('captcha_rule').value == 1)
			captcha = $('captcha_inputfield').value;
		else if($('captcha_rule').value == 2)	
			captcha = get_random();
			
		show_captcha_style(captcha);
		url_name = url_combined;

		hash_url = document.form.router_sync_desc.value + ">" + url_name + "/" + sharelink + "/" + sharelink_folder + ">" + document.form.router_sync_rule.value + ">" + captcha;
		hashed_link = f23.s52e(hash_url);
		if(router_sync != ""){			
			router_synclist_array += '&#60'+router_sync_type+'&#62'+document.form.router_sync_desc.value+'&#62'+ url_name + "/" +sharelink + document.form.router_sync_rule.value+'&#62'+captcha+'&#62' + document.form.cloud_dir.value;
		}
		else{
			router_synclist_array += router_sync_type+'&#62'+document.form.router_sync_desc.value+'&#62'+ url_name + "/" +sharelink + document.form.router_sync_rule.value+'&#62'+captcha+'&#62' + document.form.cloud_dir.value;			
		}	

		document.form.share_link_host.value = router_synclist_array.replace(/&#62/g, ">").replace(/&#60/g, "<");	
		show_invitation(hashed_link);
		document.form.submit();
}
var url_combined = "";
function domain_name_select(){
	if(ip_flag == 1 && $('host_name').value == ""){
		alert("<% tcWebApi_Get("String_Entry", "JS_fieldblank", "s") %>");
		$('host_name').focus();
		return false;
	}

	if(document.form.cloud_dir.value == ""){
		alert("<% tcWebApi_Get("String_Entry", "JS_fieldblank", "s") %>");
		document.form.cloud_dir.focus();
		return false;
	}

	if(router_sync.search(document.form.cloud_dir.value) != -1){
		alert("This folder already exists. Please select a different folder.");
		document.form.cloud_dir.value = "";
		document.form.cloud_dir.focus();
		return false;
	}

	var i;
	if(ip_flag == 0){ // Public IP
		if(ddns_enable == 1){
			url_combined += "https://" + ddns_host_name;
			apply_sharelink();
		}	
		else{
			document.ddns_form.ddns_enable_x.value = 1;
			document.ddns_form.ddns_server_x.value = "WWW.ASUS.COM";
			document.ddns_form.ddns_hostname_x.value = isMD5DDNSName;
			document.ddns_form.submit();
		}
	}
	else{ // Private IP
		if($('protocol_type').value == 0)
			url_combined += "http://";
		else		
			url_combined += "https://";

		url_combined += $('host_name').value;
			
		if($('url_port').value != "")	
 			url_combined += ":" + $('url_port').value;

		apply_sharelink();
	}
}
function apply_sharelink(){
	var sharelink_path = "";
	var sharelink_folder = "";
	var temp = $('PATH').value.split('/');

	$("update_scan").style.display = '';
	for(var i=1; i< temp.length;i++){
		if(i == 1 )
			sharelink_path += "/"+based_modelid;
		else if( i== (temp.length-1) ) 	
			sharelink_folder = temp[i];
		else
			sharelink_path += "/" + temp[i];
	
	}

	document.sharelink_form.share_link_host.disabled = true; // Do not submit share_link_host while generating the share link.
	document.sharelink_form.share_link_param.value = sharelink_path + ">" + sharelink_folder;
	document.sharelink_form.submit();
	setTimeout('get_sharelink();',2000);
}

function get_sharelink(){
	var share_link = "";
	$j.ajax({
    	url: '/cgi-bin/getsharelink.asp',
    	dataType: 'script',
    	error: function(xhr){
    		setTimeout('get_sharelink();',1000);
    	},
    	success: function(){
			share_link = share_link_result.split("&#62");
			applyRule(share_link[0]);
  		}
	});
}

function decode_router_synclist(){
	router_synclist = router_sync.replace(/>/g,"&#62").replace(/</g, "&#60"); 
	router_synclist_row = router_synclist.split("&#60");
	router_synclist_col = router_synclist_row[0].split("&#62");

	for(var i=0;i< router_synclist_row.length;i++){
		router_synclist_col = router_synclist_row[i].split("&#62");
		router_synclist_type[i] = router_synclist_col[0];
		router_synclist_desc[i] = router_synclist_col[1];
		router_synclist_sharelink[i] = router_synclist_col[2];
		router_synclist_rule[i] = router_synclist_col[3];
		router_synclist_captcha[i] = router_synclist_col[4];
		router_synclist_localfolder[i] = router_synclist_col[5];
	}
}

function get_random(){
	var temp_random;
	var i;
	var result = "";
	for(i=0;i<4;i++){
		temp_random = ""
		temp_random = Math.round(Math.random()*10);
		temp_random  = (temp_random % 9) + 1;	
		result += temp_random.toString(); 
	}

	return result;
}
function show_view_info(obj_id){
	var j = obj_id.substring(3)
	var invite_content = "";
	var sync_rule_desc = "";
	var share_link_hashed = "";
	var temp = router_synclist_localfolder[j].split('/');
	var sharelink_folder = "";
	invitation_flag = 1;
	for(var i=1; i< temp.length;i++){
		if( i == (temp.length-1) && temp.length != 1 ) 	
			sharelink_folder = temp[i];
	}
	
	//hash_url = router_synclist_desc[j] + ">" + "http://router.asus.com/" + router_synclist_sharelink[j] + "/" + sharelink_folder + ">" + router_synclist_rule[j] + ">" + router_synclist_captcha[j];
	hash_url = router_synclist_desc[j] + ">" + router_synclist_sharelink[j] + "/" + sharelink_folder + ">" + router_synclist_rule[j] + ">" + router_synclist_captcha[j];
	share_link_hashed = f23.s52e(hash_url);

	//$('invite_desc').innerHTML = "Sync description: "+document.form.router_sync_desc.value;
	$('invite_desc').innerHTML = "Sync description: "+router_synclist_desc[j];
	//$('invite_path').innerHTML = document.form.cloud_dir.value;	
	$('invite_path').innerHTML = router_synclist_localfolder[j];	
	if(router_synclist_rule[j] == 0)
		sync_rule_desc = "Two way sync";
	else if(router_synclist_rule[j] == 1)
		sync_rule_desc = "Host to client";
	else
		sync_rule_desc = "Client to host";	
	
	$('invite_rule').innerHTML = "Sync rule: "+sync_rule_desc;
	$('invite_share').innerHTML = "http://router.asus.com/"+share_link_hashed;	
	$('invite_captcha').innerHTML = "<% tcWebApi_Get("String_Entry","routerSync_Security_code","s") %>: "+ router_synclist_captcha[j];
	$('invite_captcha').innerHTML += "<br><br>We strongly suggest you giving this code separately to your friends.";
	$("mailto").innerHTML = appendMailTo();
	cal_panel_block('invitation_block'); 
	$j('#invitation_block').fadeIn(300);
}

function appendMailTo(){
	var mailtoCode = '<a href="mailto:?subject=Router%20Sync%20Invitation&body=';
	mailtoCode += "Hi,%0D%0A%0D%0A"; 
	mailtoCode += $('invite_desc').innerHTML.replace(/ /g, "%20") + "%0D%0A"; 
	mailtoCode += "Sync%20path:%20" + $('invite_path').innerHTML.replace(/ /g, "%20") + "%0D%0A"; 
	mailtoCode += $('invite_rule').innerHTML.replace(/ /g, "%20") + "%0D%0A%0D%0A"; 
	mailtoCode += "Please connect your device to ASUS router through WiFi or ethernet and click the link below to reconfirm this invitation.%0D%0A".replace(/ /g, "%20");
	mailtoCode += $('invite_share').innerHTML.replace(/ /g, "%20") + "%0D%0A"; 
	// mailtoCode += $('invite_captcha').innerHTML; 
	mailtoCode += '"><div onmouseover="" style="margin-right:15px;background-image:url(/images/cloudsync/mail_send.png);background-repeat:no-repeat;width:64px;height:64px;"></div><div style="font-size:12px;margin-top:3px;margin-right:15px;">Send mail</div></a>';
	return mailtoCode;
}

function captcha_style(){
	if( $('captcha_rule').value == 1 )
		$('captcha_input').style.display = "";
	else	
		$('captcha_input').style.display = "none";	
}
function show_block(){
	$("update_scan").style.display = 'none';
	$j('#invitation_block').fadeIn(300);
}

function valid_wan_ip() {
        // test if WAN IP is a private IP.
        var A_class_start = inet_network("10.0.0.0");
        var A_class_end = inet_network("10.255.255.255");
        var B_class_start = inet_network("172.16.0.0");
        var B_class_end = inet_network("172.31.255.255");
        var C_class_start = inet_network("192.168.0.0");
        var C_class_end = inet_network("192.168.255.255");
        
        var ip_obj = wanlink_ipaddr();
        var ip_num = inet_network(ip_obj);
        var ip_class = "";

        if(ip_num > A_class_start && ip_num < A_class_end)
                ip_class = 'A';
        else if(ip_num > B_class_start && ip_num < B_class_end)
                ip_class = 'B';
        else if(ip_num > C_class_start && ip_num < C_class_end)
                ip_class = 'C';
        else if(ip_num != 0){
			showhide("host_name_tr",0);
			showhide("wan_ip_hide2",0);
			ip_flag = 0;
			return;
        }
		
	showhide("host_name_tr",1);
	showhide("wan_ip_hide2",1);
	ip_flag = 1;
	return;
}

function check_aicloud(){
	if(webdav_aidisk == 0 || webdav_proxy ==0){
		$('title_desc_block').style.display = "none";
		$('invite_block').style.display = "none";
		$('list_block').style.display = "none";
		$('aicloud_enable_hint').style.display = "";
	}
	else{
		$('title_desc_block').style.display = "";
		$('invite_block').style.display = "";
		$('list_block').style.display = "";
		$('aicloud_enable_hint').style.display = "none";	
	}
}
var hint_string = "";
hint_string += "<% tcWebApi_Get("String_Entry", "routerSync_rule_both", "s") %><br><br>";
hint_string += "<% tcWebApi_Get("String_Entry", "routerSync_rule_StoC", "s") %><br><br>";
hint_string += "<% tcWebApi_Get("String_Entry", "routerSync_rule_CtoS", "s") %>";
</script>
</head>

<body onload="initial();" onunload="return unload_body();">
<div id="TopBanner"></div>

<!-- floder tree-->
<div id="DM_mask" class="mask_bg"></div>
<div id="folderTree_panel" class="panel_folder">
	<table><tr>
		<td>
			<div class="machineName" style="width:200px;font-family:Microsoft JhengHei;font-size:12pt;font-weight:bolder; margin-top:15px;margin-left:30px;"><% tcWebApi_get("String_Entry","Web_Title2","s") %></div>
		</td>
		<td>
			<div style="width:240px;margin-top:15px;margin-left:125px;">
				<img id="createFolderBtn" src="/images/New_ui/advancesetting/FolderAdd.png" hspace="1" title="<% tcWebApi_Get("String_Entry", "AddFolderTitle", "s") %>" onclick="">
				<img id="deleteFolderBtn" src="/images/New_ui/advancesetting/FolderDel.png" hspace="1" title="<% tcWebApi_Get("String_Entry", "DelFolderTitle", "s") %>" onclick="">
				<img id="modifyFolderBtn" src="/images/New_ui/advancesetting/FolderMod.png" hspace="1" title="<% tcWebApi_Get("String_Entry", "ModFolderTitle", "s") %>" onclick="">
			</div>
		</td>
	</tr></table>
	<div id="e0" class="folder_tree"></div>
	<div style="background-image:url(/images/Tree/bg_02.png);background-repeat:no-repeat;height:90px;margin-top:5px;">		
		<input class="button_gen" type="button" style="margin-left:27%;margin-top:18px;" onclick="cancel_folderTree();" value="<% tcWebApi_Get("String_Entry", "CTL_Cancel", "s") %>">
		<input class="button_gen" type="button"  onclick="confirm_folderTree();" value="<% tcWebApi_Get("String_Entry", "CTL_ok", "s") %>">
	</div>
</div>
<!--div id="DM_mask_floder" class="mask_floder_bg"></div-->
<!-- End of floder tree-->

<!-- invitation block-->
<!--div id="DM_mask" class="mask_bg"></div-->
<div id="invitation_block" class="panel_folder" >
	<table><tr><td>
		<div class="machineName" style="width:200px;font-family:Microsoft JhengHei;font-size:12pt;font-weight:bolder; margin-top:20px;margin-left:30px;"><% tcWebApi_Get("String_Entry", "Invitation", "s") %></div>
		</td></tr>
	</table>
	<div style="overflow:auto;margin-top:0px;height:350px;">
		<table style="padding:20px;margin-left:10px;word-break:break-all;" >
			<tr >
				<td >
					<div><% tcWebApi_Get("String_Entry", "sync_router_Invit_desc1", "s") %></div>				
				</td>
			</tr>
			<tr>
				<td>
					<div id="invite_desc" style="margin-top:10px;"></div>
					<div><% tcWebApi_Get("String_Entry", "sync_router_Invit_desc3", "s") %>:
						<span id="invite_path" style="text-decoration:underline;"></span>
					</div>
					<div id="invite_rule"></div>
				</td>
			</tr>
			<tr>
				<td>
					<div style="margin-top:10px;width:440px;"><% tcWebApi_Get("String_Entry", "sync_router_Invit_desc5", "s") %></div>
				</td>
			</tr>
			<tr>
				<td>
					<div style="text-decoration:underline;margin-top:10px;" id="invite_share"></div>
				</td>
			</tr>
			<tr>
				<td>
					<div style="margin-top:10px;height:30px;width:335px" id="invite_captcha"></div>
				</td>
			</tr>
			<tr>
				<td align="right"><div id="mailto" style="position:absolute;margin-top:0px;margin-left:375px;"></div></td>
			</tr>
		</table>
	</div>
	<div style="background-image:url(/images/Tree/bg_02.png);background-repeat:no-repeat;height:90px;">		
		<input class="button_gen" type="button"  onclick="close_invitation_block();" value="Close" style="margin-top:15px;margin-left:200px">
	</div>
</div>
<div id="DM_mask_floder" class="mask_floder_bg"></div>
<!-- End of invitation block-->
<div id="Loading" class="popup_bg"></div>
<iframe name="hidden_frame" id="hidden_frame" width="0" height="0" frameborder="0" scrolling="no"></iframe>
<form method="post" name="form" action="cloud_apply.asp" target="hidden_frame">
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<%tcWebApi_Get("SysInfo_Entry", "preferred_lang", "s")%>">
<input type="hidden" name="firmver" value="<% tcWebApi_Get("DeviceInfo", "FwVer", "s") %>">
<input type="hidden" name="current_page" value="cloud_router_sync.asp">
<input type="hidden" name="next_page" value="cloud_router_sync.asp">
<input type="hidden" name="next_host" value="">
<input type="hidden" name="modified" value="0">
<input type="hidden" name="action_mode" value="apply">
<input type="hidden" name="action_script" value="">
<input type="hidden" name="flag" value="apply_routersync">
<input type="hidden" name="action_wait" value="1">
<input type="hidden" name="share_link_host" value="<% tcWebApi_Get("AiCloud_Entry", "share_link_host", "s") %>">
<table border="0" align="center" cellpadding="0" cellspacing="0" class="content">
	<tr>
		<td valign="top" width="17">&nbsp;</td>
		<!--=====Beginning of Main Menu=====-->
		<td valign="top" width="202">
			<div id="mainMenu"></div>
			<div id="subMenu"></div>
		</td>
		<td valign="top">
			<div id="tabMenu" class="submenuBlock">
				<table border="0" cellspacing="0" cellpadding="0">
					<tbody>
					<tr>
						<td>
							<a href="cloud_main.asp"><div class="tab"><span><%tcWebApi_Get("String_Entry", "AiCloud_Title","s")%></span></div></a>
						</td>
						<td>
							<a href="cloud_sync.asp"><div class="tab"><span><% tcWebApi_Get("String_Entry","smart_sync","s") %></span></div></a>
						</td>
						<td>
							<div class="tabclick"><span><% tcWebApi_Get("String_Entry","Server_Sync","s") %></span></div>							
						</td>
						<td>
							<a href="cloud_settings.asp"><div class="tab"><span><% tcWebApi_Get("String_Entry","Settings","s") %></span></div></a>
						</td>
						<td>
							<a href="cloud_syslog.asp"><div class="tab"><span><% tcWebApi_Get("String_Entry","Log","s") %></span></div></a>
						</td>
					</tr>
					</tbody>
				</table>
			</div>

		<!--==============Beginning of hint content=============-->
			<table width="98%" border="0" align="left" cellpadding="0" cellspacing="0">
			  <tr>
					<td align="left" valign="top">
					  <table width="95%" border="0" cellpadding="5" cellspacing="0" class="FormTitle" id="FormTitle" >
						<tbody>
						<tr>
						  <td bgcolor="#4D595D" valign="top">

						<div>&nbsp;</div>
						<div class="formfonttitle">AiCloud - <% tcWebApi_Get("String_Entry","Server_Sync","s") %></div>
						<div style="margin-left:5px;margin-top:10px;margin-bottom:10px;"><img src="/images/New_ui/export/line_export.png"></div>
						<div id="title_desc_block" style="display:none;">
							<table width="700px" style="margin-left:25px;">
								<tr>
									<td>
										<img id="guest_image" src="/images/cloudsync/004.png" style="margin:10px 0px 20px -20px;">
									</td>
									<td>&nbsp;&nbsp;</td>
									<td>
										<div style="padding:10px;width:95%;font-style:italic;font-size:14px;word-break:break-all;">
										<% tcWebApi_Get("String_Entry","sync_router_desc0","s") %><br>
										1. <% tcWebApi_Get("String_Entry","sync_router_desc1","s") %><br>
										2. <% tcWebApi_Get("String_Entry","sync_router_desc2","s") %><br>
										3. <% tcWebApi_Get("String_Entry","sync_router_desc3","s") %><br>
										4. <% tcWebApi_Get("String_Entry","sync_router_desc4","s") %><br>
										<span class="formfontdesc" id="wan_ip_hide2" style="color:#FFCC00;display:none;margin-left:0px;">5. <% tcWebApi_Get("String_Entry","sync_router_desc5","s") %></span>									
										</div>
									</td>
								</tr>
							</table>
						</div>
					
						<div id="invite_block"  style="display:none;font-size:18px;word-break:break-all;border-radius:10px;border-width:1px;border-color:#999;background-color:#444f53;">						
							<div class="invitation_head" style="height:40px;font-weight:bold;">
								<table>
									<tr>
										<td>
											<div style="margin-left:15px;margin-top:3px;"><% tcWebApi_Get("String_Entry","sync_router_Invitation", "s") %></div>
										</td>
									</tr>
								</table>
							</div>	
							<div>
								<img src="/images/New_ui/midup_bg.png" width="751px;">
								<table  width="736px" height="200px;" style="text-align:left;margin-left:15px;position:absolute;margin-top:-130px;*margin-left:-740px;*margin-top:0px;">
									<tr style="height:40px;">
										<th width="25%"><% tcWebApi_Get("String_Entry","IPC_autofwDesc_in","s") %></th>
										<td>
											<input name="router_sync_desc" type="text" class="input_32_table" style="height:25px;font-size:13px;"  value="My new sync">
										</td>
									</tr>
									<tr id="host_name_tr">
										<th width="25%"><% tcWebApi_Get("String_Entry","LHC_x_DDNSHostNames_in","s") %></th>
										<td>
											<select id="protocol_type" class="input_option" style="height:27px;">
												<option value="0">Http</option>
												<option value="1">Https</option>
											</select>
											<input id="host_name" type="text" maxlength="32"  class="input_32_table" style="height:25px;font-size:13px;"  onKeyPress="return validator.isString(this, event)">&nbsp:
											<input type="text" maxlength="6" id="url_port" class="input_6_table" style="height:25px;font-size:13px;"  onKeyPress="return validator.isString(this, event)">
										</td>
									</tr>
									<tr style="height:40px;">
										<th>
											<div style="margin-top:5px;"><% tcWebApi_Get("String_Entry","sync_router_localfolder","s") %></div>
										</th>
										<td>
											<input type="text" id="PATH" class="input_25_table" style="height: 25px;" name="cloud_dir" value="" >
											<input name="button" type="button" class="button_gen_short" onclick="get_disk_tree();" value="<% tcWebApi_Get("String_Entry","Cloudsync_browser_folder","s") %>"/>
											<div id="noUSB" style="color:#FC0;display:none;margin-left:3px;font-size:12px;line-height:140%;"><% tcWebApi_Get("String_Entry", "no_usb_found", "s") %></div>
										</td>
									</tr>
									<tr style="height:40px;">
										<th>
											<div style="margin-top:5px;"><% tcWebApi_Get("String_Entry", "Cloudsync_Rule", "s") %></div>
										</th>
										<td>										
											<select name="router_sync_rule" class="input_option" style="height:27px;">
												<option value="0"><% tcWebApi_Get("String_Entry","routerSync_ruleBoth","s") %></option>
												<option value="1"><% tcWebApi_Get("String_Entry","routerSync_ruleStoC","s") %></option>
												<option value="2"><% tcWebApi_Get("String_Entry","routerSync_ruleCtoS","s") %></option>
											</select>
											<span>											
												<img align="center" style="cursor:pointer;margin-top:-14px\9;" src="/images/New_ui/helpicon.png" onclick="overlib(hint_string)" onmouseout="return nd();">
											</span>
										</td>				
									</tr>
									<tr style="height:40px;">
										<th><% tcWebApi_Get("String_Entry","routerSync_Security_code","s") %></th>
										<td>
											<div >
												<select id="captcha_rule" class="input_option" onchange="captcha_style()" style="height:27px;">
													<option value="0"><%tcWebApi_get("String_Entry","checkbox_No","s")%></option>
													<option value="1"><%tcWebApi_get("String_Entry","Manual_Setting_assign","s")%></option>
													<option value="2"><%tcWebApi_get("String_Entry","sync_router_generate","s")%></option>
												</select>
												<span id="captcha_input" style="display:none;">											
													<input id="captcha_inputfield" type="text" class="input_6_table" style="margin-left:10px;" maxlength="4" value="" onclick=""  onkeypress="return validator.isNumber(this,event);">
												</span>
											</div>
										</td>				
									</tr>
									<tr style="height:40px;">
										<td colspan="2">
											<div style="text-align:center;margin-top:10px;margin-bottom:10px;">
												<input  type="button" id="applyButton" class="button_gen" value="<%tcWebApi_get("String_Entry","CTL_Generate","s")%>" onclick="domain_name_select();">
												<img id="update_scan" style="display:none;" src="/images/InternetScan.gif" />
											</div>
										</td>
									</tr>	
								</table>
								<img src="/images/New_ui/middown_bg.png" height="150px" width="751px;" style="*margin-top:-4px;*margin-bottom:-4px;">
							</div>
							<div  class="invitation_foot" style="height:20px;"></div>
							<div style="position:absolute;margin:-175px 0px 0px 500px;"><img src="/images/cloudsync/invite_model.jpg" ></div>
						</div>
						<div id="aicloud_enable_hint" style="display:none;position:absolute;font-family: Arial, Helvetica, sans-serif;font-size: 18px;font-weight: bold;line-height: 150%;margin-top: 150px;margin-left: 170px;" >
							<table >
								<tr>
									<td>
										<div ><% tcWebApi_Get("String_Entry", "nosmart_sync", "s") %></div>
										<a href="cloud_main.asp"><span style="margin-left:155px;font-family:Lucida Console;text-decoration:underline;color:#FC0"><% tcWebApi_Get("String_Entry", "btn_go", "s") %></span></a>
									</td>
								</tr>
							</table>
						</div>
					<div id="list_block" style="display:none;">	
   					<table width="99%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable_table" id="cloudlistTable" style="margin-top:20px;">
	  					<thead>
							<tr>
								<td colspan="6" id="cloud_synclist"><% tcWebApi_Get("String_Entry","sync_router_list","s") %></td>
							</tr>
	  					</thead>		  
    					<tr>
							<th width="10%"><% tcWebApi_Get("String_Entry","Provider","s") %></th>
							<th width="25%"><% tcWebApi_Get("String_Entry","IPC_autofwDesc_in","s") %></a></th>
							<th width="10%"><% tcWebApi_Get("String_Entry","sync_router_Invit_desc4","s") %></a></th>
							<th width="30%"><% tcWebApi_Get("String_Entry","sync_router_localfolder","s") %></th>
							<th width="15%"><% tcWebApi_Get("String_Entry", "Invitation", "s") %></th>
							<th width="10%"><% tcWebApi_Get("String_Entry", "CTL_del", "s") %></th>
    					</tr>
					</table>
	
						<div id="cloud_synclist_Block"></div>


	  				<div class="apply_gen" id="creatBtn" style="margin-top:30px;">
							<input name="applybutton" id="applybutton" type="button" class="button_gen" onclick="location.href='cloud_syslog.asp'" value="<% tcWebApi_Get("String_Entry", "CTL_check_log", "s") %>" style="word-wrap:break-word;word-break:normal;">
							<!--img id="update_scan" style="display:none;" src="images/InternetScan.gif" /-->
	  				</div>
					</div>
					  </td>
					</tr>				
					</tbody>	
				  </table>		
	
					</td>
				</tr>
			</table>
		</td>
		<td width="20"></td>
	</tr>
</table>
<div id="footer"></div>
</form>
<form method="post" name="enableform" action="cloud_apply.asp" target="hidden_frame">
<input type="hidden" name="preferred_lang" value="<%tcWebApi_Get("SysInfo_Entry", "preferred_lang", "s")%>">
<input type="hidden" name="firmver" value="<% tcWebApi_Get("DeviceInfo", "FwVer", "s") %>">
<input type="hidden" name="current_page" value="cloud_sync.asp">
<input type="hidden" name="next_page" value="cloud_sync.asp">
<input type="hidden" name="next_host" value="">
<input type="hidden" name="modified" value="0">
<input type="hidden" name="action_mode" value="apply">
<input type="hidden" name="action_script" value="restart_cloudsync">
<input type="hidden" name="action_wait" value="2">
</form>
<form method="post" name="aidiskForm" action="" target="hidden_frame">
<input type="hidden" name="motion" id="motion" value="">
<input type="hidden" name="layer_order" id="layer_order" value="">
<input type="hidden" name="test_flag" value="" disabled="disabled">
<input type="hidden" name="protocol" id="protocol" value="">
</form>
<!-- mask for disabling AiDisk -->
<form method="post" name="sharelink_form" action="cloud_apply2.asp" target="hidden_frame">
<input type="hidden" name="action_mode" value="get_sharelink">
<input type="hidden" name="action_script" value="">
<input type="hidden" name="action_wait" value="">
<input type="hidden" name="share_link_param" value="" style="width: 200px">
<input type="hidden" name="share_link_host" value="">
<input type="hidden" name="flag" value="delete_share_link">
</form>
<!-- for DDNS register -->
<form method="post" name="ddns_form" action="start_apply.asp" target="hidden_frame">
<input type="hidden" name="flag" value="router_sync_ddns">
<input type="hidden" name="action_wait" value="">
<input type="hidden" name="action_mode" value="apply">
<input type="hidden" name="action_script" value="restart_ddns">
<input type="hidden" name="ddns_enable_x" value="">
<input type="hidden" name="ddns_server_x" value="">
<input type="hidden" name="ddns_hostname_x" value="">
</form>
<div id="OverlayMask" class="popup_bg">
	<div align="center">
	<iframe src="" frameborder="0" scrolling="no" id="popupframe" width="400" height="400" allowtransparency="true" style="margin-top:150px;"></iframe>
	</div>
<!--[if lte IE 6.5]><iframe class="hackiframe"></iframe><![endif]-->
</div>
</body>
</html>
