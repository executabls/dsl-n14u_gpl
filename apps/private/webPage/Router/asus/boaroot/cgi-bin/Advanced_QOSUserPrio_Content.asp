<% If Request_Form("apply_flag") = "1" then
	tcWebApi_set("QoS_Entry0","qos_irates", "qos_irates")
	tcWebApi_set("QoS_Entry0","qos_orates", "qos_orates")
	
	tcWebApi_set("QoS_Entry0","qos_ack", "qos_ack")
	tcWebApi_set("QoS_Entry0","qos_syn", "qos_syn")
	tcWebApi_set("QoS_Entry0","qos_fin", "qos_fin")
	tcWebApi_set("QoS_Entry0","qos_rst", "qos_rst")
	tcWebApi_set("QoS_Entry0","qos_icmp", "qos_icmp")
	tcWebApi_CommitWithoutSave("Firewall")
	tcWebApi_commit("QoS")
End If
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<html xmlns:v>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<link rel="shortcut icon" href="images/favicon.png">
<link rel="icon" href="images/favicon.png">
<title>ASUS <% tcWebApi_get("String_Entry","Web_Title2","s") %> <% tcWebApi_get("SysInfo_Entry","ProductTitle","s") %> - EZQoS Bandwidth Management</title>
<link rel="stylesheet" type="text/css" href="/index_style.css"> 
<link rel="stylesheet" type="text/css" href="/form_style.css">
<script language="JavaScript" type="text/javascript" src="/state.js"></script>
<script language="JavaScript" type="text/javascript" src="/help.js"></script>
<script language="JavaScript" type="text/javascript" src="/general.js"></script>
<script language="JavaScript" type="text/javascript" src="/popup.js"></script>
<script language="JavaScript" type="text/javascript" src="/detect.js"></script>
<script language="JavaScript" type="text/javascript" src="/validator.js"></script>
<script>
wan_route_x = '';
wan_nat_x = '1';
wan_proto = 'pppoe';
<% login_state_hook(); %>
var wireless = [<% wl_auth_list() %>];	// [[MAC, associated, authorized], ...]
var qos_orates = '<% tcWebApi_get("QoS_Entry0", "qos_orates", "s") %>';
var qos_irates = '<% tcWebApi_get("QoS_Entry0", "qos_irates", "s") %>';

function initial(){
	show_menu();	
	init_changeScale("qos_obw");
	init_changeScale("qos_ibw");
	//load_QoS_rule();
	
	if( '<%tcWebApi_get("QoS_Entry0","qos_enable","s")%>' == '1' )
		$('is_qos_enable_desc').style.display = "none";

	
	
}

function init_changeScale(_obj_String){
	if($(_obj_String).value > 999){
		$(_obj_String+"_scale").value = "Mb/s";
		$(_obj_String).value = Math.round(($(_obj_String).value/1024)*100)/100;
	}

	gen_options();
}

function changeScale(_obj_String){
	if($(_obj_String+"_scale").value == "Mb/s")
		$(_obj_String).value = Math.round(($(_obj_String).value/1024)*100)/100;
	else
		$(_obj_String).value = Math.round($(_obj_String).value*1024);
		
	gen_options();
}

function applyRule(){
	if(save_options() != false){
		if($("qos_obw_scale").value == "Mb/s"){
			//document.form.qos_obw.value = Math.round(document.form.qos_obw.value*1024);
			document.form.qos_obw.value = document.form.qos_obw_orig.value;
		}	

		if($("qos_ibw_scale").value == "Mb/s"){
			//document.form.qos_ibw.value = Math.round(document.form.qos_ibw.value*1024);
			document.form.qos_ibw.value = document.form.qos_ibw_orig.value;
		}
		
		save_checkbox();
		
		/* Viz banned 2012.07.30
		if(document.form.qos_enable.value != document.form.qos_enable_orig.value)
    	FormActions("start_apply.htm", "apply", "reboot", "<% get_default_reboot_time(); %>"); */
    	
		//if(wl6_support != -1)
		//	document.form.action_wait.value = parseInt(document.form.action_wait.value)+10;			// extend waiting time for BRCM new driver

		document.form.action = "/cgi-bin/Advanced_QOSUserPrio_Content.asp";
		document.form.apply_flag.value = 1;
		showLoading(5);
		setTimeout('location = "'+ location.pathname +'";', 5000);
		document.form.submit();
	}
}

function save_checkbox(){
	document.form.qos_ack.value = document.form.qos_ack_checkbox.checked ? "on" : "off";
	document.form.qos_syn.value = document.form.qos_syn_checkbox.checked ? "on" : "off";
	document.form.qos_fin.value = document.form.qos_fin_checkbox.checked ? "on" : "off";
	document.form.qos_rst.value = document.form.qos_rst_checkbox.checked ? "on" : "off";
	document.form.qos_icmp.value = document.form.qos_icmp_checkbox.checked ? "on" : "off";
}

function save_options(){
	document.form.qos_orates.value = "";
	for(var j=0; j<5; j++){
		var upload_bw_max = eval("document.form.upload_bw_max_"+j);
		var upload_bw_min = eval("document.form.upload_bw_min_"+j);
		var download_bw_max = eval("document.form.download_bw_max_"+j);
		if(parseInt(upload_bw_max.value) < parseInt(upload_bw_min.value)){
			alert("<% tcWebApi_Get("String_Entry", "QoS_invalid_period", "s") %>");
			upload_bw_max.focus();
			return false;
		}

		document.form.qos_orates.value += upload_bw_min.value + "-" + upload_bw_max.value + ",";
		document.form.qos_irates.value += download_bw_max.value + ",";
	}
	document.form.qos_orates.value += "0-0,0-0,0-0,0-0,0-0";
	document.form.qos_irates.value += "0,0,0,0,0";
	return true;
}

function done_validating(action){
	refreshpage();
}

function addRow(obj, head){
	if(head == 1)
		qos_rulelist_array += "<"
	else
		qos_rulelist_array += ">"
			
	qos_rulelist_array += obj.value;
	obj.value= "";
	document.form.qos_min_transferred_x_0.value= "";
	document.form.qos_max_transferred_x_0.value= "";
}

function validForm(){
	if(!Block_chars(document.form.qos_service_name_x_0, ["<" ,">" ,"'" ,"%"])){
				return false;		
	}
	
	if(!valid_IPorMAC(document.form.qos_ip_x_0)){
		return false;
	}
	
	replace_symbol();
	if(document.form.qos_port_x_0.value != "" && !Check_multi_range(document.form.qos_port_x_0, 1, 65535)){
		parse_port="";
		return false;
	}	
		
	if(document.form.qos_max_transferred_x_0.value.length > 0 
	   && document.form.qos_max_transferred_x_0.value < document.form.qos_min_transferred_x_0.value){
				document.form.qos_max_transferred_x_0.focus();
				alert("<% tcWebApi_Get("String_Entry", "vlaue_haigher_than", "s") %> "+document.form.qos_min_transferred_x_0.value);	
				return false;
	}
	
	return true;
}

function conv_to_transf(){
	if(document.form.qos_min_transferred_x_0.value == "" && document.form.qos_max_transferred_x_0.value =="")
		document.form.qos_transferred_x_0.value = "";
	else
		document.form.qos_transferred_x_0.value = document.form.qos_min_transferred_x_0.value + "~" + document.form.qos_max_transferred_x_0.value;
}

function gen_options(){
	if($("upload_bw_min_0").innerHTML == ""){
		var qos_orates_row = qos_orates.split(',');
		var qos_irates_row = qos_irates.split(',');
		for(var j=0; j<5; j++){
			var upload_bw_max = eval("document.form.upload_bw_max_"+j);
			var upload_bw_min = eval("document.form.upload_bw_min_"+j);
			var download_bw_max = eval("document.form.download_bw_max_"+j);
			//Viz 2011.06 var download_bw_min = eval("document.form.download_bw_min_"+j);
			//var qos_orates_col = qos_orates_row[j].split('-');
			var qos_orates_col = qos_orates_row[j]?qos_orates_row[j].split('-'):'';
			//var qos_irates_col = qos_irates_row[j].split('-');
			var qos_irates_col = qos_irates_row[j]?qos_irates_row[j].split('-'):'';
			for(var i=0; i<101; i++){
				add_options_value(upload_bw_min, i, qos_orates_col[0]);
				add_options_value(upload_bw_max, i, qos_orates_col[1]);
				add_options_value(download_bw_max, i, qos_irates_col[0]);
			}
			var upload_bw_desc = eval('document.getElementById("upload_bw_'+j+'_desc")');
			var download_bw_desc = eval('document.getElementById("download_bw_'+j+'_desc")');	
			//upload_bw_desc.innerHTML = Math.round(upload_bw_min.value*document.form.qos_obw.value)/100 + " ~ " + Math.round(upload_bw_max.value*document.form.qos_obw.value)/100 + " " + $("qos_obw_scale").value;
			//download_bw_desc.innerHTML = "0 ~ " + Math.round(download_bw_max.value*document.form.qos_ibw.value)/100 + " " + $("qos_ibw_scale").value;
		}
	}
	else{
		for(var j=0; j<5; j++){
			var upload_bw_max = eval("document.form.upload_bw_max_"+j);
			var upload_bw_min = eval("document.form.upload_bw_min_"+j);
			var download_bw_max = eval("document.form.download_bw_max_"+j);
			var upload_bw_desc = eval('document.getElementById("upload_bw_'+j+'_desc")');
			var download_bw_desc = eval('document.getElementById("download_bw_'+j+'_desc")');	
			upload_bw_desc.innerHTML = Math.round(upload_bw_min.value*document.form.qos_obw_orig.value)/100 + " ~ " + Math.round(upload_bw_max.value*document.form.qos_obw_orig.value)/100 + " " + $("qos_obw_scale").value;
			download_bw_desc.innerHTML = "0 ~ " + Math.round(download_bw_max.value*document.form.qos_ibw_orig.value)/100 + " " + $("qos_ibw_scale").value;
		}
	}
}

function add_options_value(o, arr, orig){
	if(orig == arr)
		add_option(o, arr, arr, 1);
	else
		add_option(o, arr, arr, 0);
}

function switchPage(page){
		
	if(page == "1")
		location.href = "QoS_EZQoS.asp";
	else if(page == "3")
		location.href = "Advanced_QOSUserRules_Content.asp";	
	else
    		return false;
}

</script>
</head>

<body onLoad="initial();" onunLoad="return unload_body();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<form method="post" name="form" id="ruleForm" action="/start_apply.htm" target="hidden_frame">
<input type="hidden" name="current_page" value="Advanced_QOSUserPrio_Content.asp">
<input type="hidden" name="next_page" value="">
<input type="hidden" name="next_host" value="">
<input type="hidden" name="modified" value="0">
<input type="hidden" name="action_mode" value="apply">
<input type="hidden" name="action_wait" value="5">
<input type="hidden" name="action_script" value="restart_qos">
<input type="hidden" name="first_time" value="">
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% tcWebApi_get("SysInfo_Entry","preferred_lang","s") %>">
<input type="hidden" name="firmver" value="<% tcWebApi_get("SysInfo_Entry","FWVer","s") %>">
<input type="hidden" name="qos_orates" value=''>
<input type="hidden" name="qos_irates" value=''>
<input type="hidden" name="qos_obw_orig" id="qos_obw" value="<% tcWebApi_get("QoS_Entry0", "qos_obw", "s") %>">
<input type="hidden" name="qos_ibw_orig" id="qos_ibw" value="<% tcWebApi_get("QoS_Entry0", "qos_ibw", "s") %>">
<!-- input type="hidden" name="qos_enable_orig" value="<% tcWebApi_get("QoS_Entry0", "qos_enable", "s") %>">
<input type="hidden" name="qos_enable" value="1" -->

<table class="content" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td width="17">&nbsp;</td>		
		<td valign="top" width="202">				
			<div id="mainMenu"></div>	
			<div id="subMenu"></div>		
		</td>				
		<td valign="top">
			<div id="tabMenu" class="submenuBlock"></div>
			<!--===================================Beginning of Main Content===========================================-->
<table width="98%" border="0" align="left" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<table width="760px" border="0" cellpadding="4" cellspacing="0" class="FormTitle" id="FormTitle">
				<tr>
		  			<td bgcolor="#4D595D" valign="top">
						<table>
						<tr>
						<td>
						<table width="100%" >
						<tr >
						<td  class="formfonttitle" align="left">								
							<div style="margin-top:5px;"><% tcWebApi_Get("String_Entry", "Menu_TrafficManager", "s") %> - QoS</div>
						</td>
						<td align="right" >	
						<div style="margin-top:5px;">
	   					<select onchange="switchPage(this.options[this.selectedIndex].value)" class="input_option">
							<!--option>Switch Pages:</option-->
							<option value="1"><%tcWebApi_get("String_Entry","Adaptive_QoS_Conf","s")%></option>
							<option value="2" selected><% tcWebApi_Get("String_Entry", "qos_user_prio", "s") %></option>
							<option value="3" ><% tcWebApi_Get("String_Entry", "qos_user_rules", "s") %></option>
						</select>	    
						</div>
						
						</td>
						</tr>
						</table>
						</td>
						</tr>
						
						
		  			<tr>
          				<td height="5"><img src="/images/New_ui/export/line_export.png" /></td>
        			</tr>
					<tr>
						<td style="font-style: italic;font-size: 14px;">
		  				<div class="formfontdesc" id="user_qos_description"><% tcWebApi_Get("String_Entry", "UserQoS_desc", "s") %></div>
							<div class="formfontdesc" id="is_qos_enable_desc" style="color:#FFCC00;"><% tcWebApi_Get("String_Entry", "UserQoS_desc_zero", "s") %></div>
		  			</td>
					</tr>

					<tr><td>		
						<table width="100%"  border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable">
							<thead>	
							<tr>
								<td colspan="2"><div><% tcWebApi_Get("String_Entry", "set_rate_limit", "s") %></div></td>
							</tr>
							</thead>	

							<tr>
								<td>
										<table width="100%" border="0" cellpadding="4" cellspacing="0">
										<tr>
											<td width="58%" style="font-size:12px; border-collapse: collapse;border:0; padding-left:0;">			  
												<table width="100%" border="0" cellpadding="4" cellspacing="0" style="font-size:12px; border-collapse: collapse;border:0;">
												<thead>	
												<tr>
													<td colspan="4"><% tcWebApi_Get("String_Entry", "upload_bandwidth", "s") %></td>
												</tr>
												<tr style="height: 55px;">
													<th style="width:22%;line-height:15px;color:#FFFFFF;"><% tcWebApi_Get("String_Entry", "upload_prio", "s") %></th>
													<th style="width:25%;line-height:15px;color:#FFFFFF;"><a href="javascript:void(0);" onClick="openHint(20,3);"><div class="table_text"><%tcWebApi_get("String_Entry","min_bound","s")%></div></a></th>
													<th style="width:26%;line-height:15px;color:#FFFFFF;"><a href="javascript:void(0);" onClick="openHint(20,4);"><div class="table_text"><%tcWebApi_get("String_Entry","max_bound","s")%></div></a></th>
													<th style="width:27%;line-height:15px;color:#FFFFFF;"><%tcWebApi_get("String_Entry","current_settings","s")%></th>
												</tr>
												</thead>												
												<tr>
													<th style="width:22%;line-height:15px;"><%tcWebApi_get("String_Entry","Highest","s")%></th>
													<td align="center"> 
														<select name="upload_bw_min_0" class="input_option" id="upload_bw_min_0" onchange="gen_options();"></select>
														<span style="color:white">%</span>
													</td>	
													<td align="center">
														<select name="upload_bw_max_0" class="input_option" id="upload_bw_max_0" onchange="gen_options();"></select>
														<span style="color:white">%</span>
													</td>
													<td align="center">
														<div id="upload_bw_0_desc"></div>
													</td>
												</tr>
												<tr>
													<th style="width:22%;line-height:15px;"><%tcWebApi_get("String_Entry","High","s")%></th>
													<td align="center">
														<select name="upload_bw_min_1" class="input_option" id="upload_bw_min_1" onchange="gen_options();"></select>
														<span style="color:white">%</span>
													</td>	
													<td  align="center">
														<select name="upload_bw_max_1" class="input_option" id="upload_bw_max_1" onchange="gen_options();"></select>
														<span style="color:white">%</span>
													</td>
													<td align="center">
														<div id="upload_bw_1_desc"></div>
													</td>
												</tr>
												<tr>
													<th style="width:22%;line-height:15px;"><%tcWebApi_get("String_Entry","Medium","s")%></th>
													<td align="center">
														<select name="upload_bw_min_2" class="input_option" id="upload_bw_min_2" onchange="gen_options();"></select>
														<span style="color:white">%</span>
													</td>	
													<td align="center">
														<select name="upload_bw_max_2" class="input_option" id="upload_bw_max_2" onchange="gen_options();"></select>
														<span style="color:white">%</span>
													</td>
													<td align="center">
														<div id="upload_bw_2_desc"></div>
													</td>
												</tr>
												<tr>
													<th style="width:22%;line-height:15px;"><%tcWebApi_get("String_Entry","Low","s")%></th>
													<td align="center">
														<select name="upload_bw_min_3" class="input_option" id="upload_bw_min_3" onchange="gen_options();"></select>
														<span style="color:white">%</span>
													</td>	
													<td align="center">
														<select name="upload_bw_max_3" class="input_option" id="upload_bw_max_3" onchange="gen_options();"></select>
														<span style="color:white">%</span>
													</td>
													<td align="center">
														<div id="upload_bw_3_desc"></div>
													</td>
												</tr>
												<tr>
													<th style="width:22%;line-height:15px;"><%tcWebApi_get("String_Entry","Lowest","s")%></th>
													<td align="center">
														<select name="upload_bw_min_4" class="input_option" id="upload_bw_min_4" onchange="gen_options();"></select>
														<span style="color:white">%</span>
													</td>	
													<td align="center">
														<select name="upload_bw_max_4" class="input_option" id="upload_bw_max_4" onchange="gen_options();"></select>
														<span style="color:white">%</span>
													</td>
													<td align="center">
														<div id="upload_bw_4_desc"></div>
													</td>
												</tr>
												</table>
											</td>

											<td width="42%" style="font-size:12px; border-collapse: collapse;border:0;">
												<table width="100%" border="0" cellpadding="4" cellspacing="0" style="font-size:12px; border-collapse: collapse;border:0;">
												<thead>
												<tr>
													<td colspan="3"><% tcWebApi_Get("String_Entry", "download_bandwidth", "s") %></td>
												</tr>
												<tr style="height: 55px;">
													<th style="width:31%;line-height:15px;color:#FFFFFF;"><% tcWebApi_Get("String_Entry", "download_prio", "s") %></th>
													<th style="width:37%;line-height:15px;color:#FFFFFF;"><a href="javascript:void(0);" onClick="openHint(20,5);"><div class="table_text"><%tcWebApi_get("String_Entry","max_bound","s")%></div></a></th>
													<th style="width:32%;line-height:15px;color:#FFFFFF;"><%tcWebApi_get("String_Entry","current_settings","s")%></th>
												</tr>
												</thead>
												<tr>
													<th style="width:31%;line-height:15px;"><%tcWebApi_get("String_Entry","Highest","s")%></th>
													<td align="center"> 
														<select name="download_bw_max_0" class="input_option" id="download_bw_max_0" onchange="gen_options();"></select>
														<span style="color:white">%</span>														
													</td>
													<td align="center">
														<div id="download_bw_0_desc"></div>
													</td>
												</tr>
												<tr>
													<th style="width:31%;line-height:15px;"><%tcWebApi_get("String_Entry","High","s")%></th>
													<td align="center">
														<select name="download_bw_max_1" class="input_option" id="download_bw_max_1" onchange="gen_options();"></select>
														<span style="color:white">%</span>
													</td>
													<td align="center">
														<div id="download_bw_1_desc"></div>
													</td>
												</tr>
												<tr>
													<th style="width:31%;line-height:15px;"><%tcWebApi_get("String_Entry","Medium","s")%></th>
													<td align="center">			  
														<select name="download_bw_max_2" class="input_option" id="download_bw_max_2" onchange="gen_options();"></select>
														<span style="color:white">%</span>
													</td>
													<td align="center">
														<div id="download_bw_2_desc"></div>
													</td>
												</tr>
												<tr>
													<th style="width:31%;line-height:15px;"><%tcWebApi_get("String_Entry","Low","s")%></th>
													<td align="center">
														<select name="download_bw_max_3" class="input_option" id="download_bw_max_3" onchange="gen_options();"></select>
														<span style="color:white">%</span>
													</td>
													<td align="center">
														<div id="download_bw_3_desc"></div>
													</td>
												</tr>
												<tr>
													<th style="width:31%;line-height:15px;"><%tcWebApi_get("String_Entry","Lowest","s")%></th>
													<td align="center">
														<select name="download_bw_max_4" class="input_option" id="download_bw_max_4" onchange="gen_options();"></select>
														<span style="color:white">%</span>
													</td>
													<td align="center">
														<div id="download_bw_4_desc"></div>
													</td>
												</tr>
												</table>
											</td>
										</tr>
										</table>
								</td>
							</tr>		  
							</table>

						</td></tr>
						<tr><td>
						<table width="100%"  border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable" style="margin-top:8px;">
							<thead>
							<tr>
							<td><%tcWebApi_get("String_Entry","highest_prio_packet","s")%>
									<a id="packet_table_display_id" style="margin-left:490px;display:none;" onclick='bw_crtl_display("packet_table_display_id", "packet_table");'>-</a>
								</td>
							</tr>
							</thead>							

							<tr>
								<td>
									<div id="packet_table">
										<table width="100%" border="0" cellpadding="4" cellspacing="0">
											<tr><td colspan="5" style="font-size:12px; border-collapse: collapse;border:0;">
														<span id="prio_packet_note"><% tcWebApi_Get("String_Entry", "prio_packet_note", "s") %></span>
													</td>
											</tr>
											<tr>
												<td style="font-size:12px; border-collapse: collapse;border:0;">		
													<input type="checkbox" name="qos_ack_checkbox" <% if tcWebApi_get("QoS_Entry0","qos_ack","h") = "on" then asp_write("checked") end if %>>ACK
													<input type="hidden" name="qos_ack">
												</td>
												<td style="font-size:12px; border-collapse: collapse;border:0;">
													<input type="checkbox" name="qos_syn_checkbox" <% if tcWebApi_get("QoS_Entry0","qos_syn","h") = "on" then asp_write("checked") end if %>>SYN
													<input type="hidden" name="qos_syn">
												</td>
												<td style="font-size:12px; border-collapse: collapse;border:0;">
													<input type="checkbox" name="qos_fin_checkbox" <% if tcWebApi_get("QoS_Entry0","qos_fin","h") = "on" then asp_write("checked") end if %>>FIN
													<input type="hidden" name="qos_fin">
												</td>
												<td style="font-size:12px; border-collapse: collapse;border:0;">
													<input type="checkbox" name="qos_rst_checkbox" <% if tcWebApi_get("QoS_Entry0","qos_rst","h") = "on" then asp_write("checked") end if %>>RST
													<input type="hidden" name="qos_rst">
												</td>
												<td style="font-size:12px; border-collapse: collapse;border:0;">
													<input type="checkbox" name="qos_icmp_checkbox" <% if tcWebApi_get("QoS_Entry0","qos_icmp","h") = "on" then asp_write("checked") end if %>>ICMP
													<input type="hidden" name="qos_icmp">
												</td>
											</tr>
										</table>
									</div>
								</td>
							</tr>
						</table>
					</td></tr>	
					<tr><td>
					<div class="apply_gen">
						<input type="hidden" name="apply_flag" value="0">
						<input name="button" type="button" class="button_gen" onClick="applyRule()" value="<%tcWebApi_get("String_Entry","CTL_apply","s")%>"/>
					</div>
					</td></tr>
					<tr><td>					
					<div id="manual_BW_setting" style="display:none;">
						<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
							<thead>
							<tr>
								<td colspan="2">Bandwidth Status</td>
							</tr>
							</thead>
							
							<tr>
								<th><a class="hintstyle" href="javascript:void(0);" onClick="openHint(20, 2);">Upload Bandwidth</a></th>
								<td>
									<input type="text" maxlength="10" id="qos_obw" name="qos_obw" onKeyPress="return validator.isNumber(this,event);" class="input_15_table" value="<% tcWebApi_get("QoS_Entry0", "qos_obw", "s") %>" onblur="gen_options();">
									<select id="qos_obw_scale" class="input_option" style="width:87px;" onChange="changeScale('qos_obw');">
										<option value="Kb/s">Kb/s</option>
										<option value="Mb/s">Mb/s</option>
									</select>
								</td>
							</tr>
							
							<tr>
								<th><a class="hintstyle" href="javascript:void(0);" onClick="openHint(20, 2);">Download Bandwidth</a></th>
								<td>
									<input type="text" maxlength="10" id="qos_ibw" name="qos_ibw" onKeyPress="return validator.isNumber(this,event);" class="input_15_table" value="<% tcWebApi_get("QoS_Entry0", "qos_ibw", "s") %>" onblur="gen_options();">
									<select id="qos_ibw_scale" class="input_option" style="width:87px;" onChange="changeScale('qos_ibw');">
										<option value="Kb/s">Kb/s</option>
										<option value="Mb/s">Mb/s</option>
									</select>
								</td>
							</tr>
						</table>
					</div>	
					</td></tr>
						</table>						
					</td>
				</tr>
		
			</table>
		</td>
</form>


      </tr>
      </table>				
		<!--===================================Ending of Main Content===========================================-->		
	</td>
		
    <td width="10" align="center" valign="top">&nbsp;</td>
	</tr>
</table>

<div id="footer"></div>

</body>
</html>
