<% If Request_Form("apply_flag") = "1" then
	tcWebApi_set("QoS_Entry0","qos_rulelist", "qos_rulelist")
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
<script language="JavaScript" type="text/javascript" src="/jquery.js"></script>
<style>
.Portrange{
	font-size: 12px;
	font-family: Lucida Console;
}
</style>
<script>
var $j = jQuery.noConflict();
wan_route_x = '';
wan_nat_x = '1';
wan_proto = 'pppoe';

<% login_state_hook(); %>
var wireless = [<% wl_auth_list() %>];	// [[MAC, associated, authorized], ...]

var qos_rulelist_array = "<% tcWebApi_get("QoS_Entry0","qos_rulelist","s") %>";

var overlib_str0 = new Array();	//Viz add 2011.06 for record longer qos rule desc
var overlib_str = new Array();	//Viz add 2011.06 for record longer portrange value

var IPC_VSList_Norule = "No data in table.";

function key_event(evt){
	if(evt.keyCode != 27 || isMenuopen == 0) 
		return false;
	pullQoSList(document.getElementById("pull_arrow"));
}

function initial(){
	show_menu();
	setTimeout("update_FAQ();", 300);
	showqos_rulelist();

	load_QoS_rule();
	if( '<%tcWebApi_get("QoS_Entry0","qos_enable","s")%>' == '1' )
		document.getElementById("is_qos_enable_desc").style.display = "none";
}

function update_FAQ(){
	if(document.getElementById("connect_status").className == "connectstatuson"){		
		faqURL("faq", "https://www.asus.com", "/support/FAQ/", "1010951");
	}
}
function applyRule(){	

		save_table();
		
		/* Viz banned 2012.07.30
		if(document.form.qos_enable.value != document.form.qos_enable_orig.value)
    	FormActions("start_apply.htm", "apply", "reboot", "<% get_default_reboot_time(); %>"); */		
    	
		//if(wl6_support != -1)
		//	document.form.action_wait.value = parseInt(document.form.action_wait.value)+10;			// extend waiting time for BRCM new driver

		document.form.action = "/cgi-bin/Advanced_QOSUserRules_Content.asp";
		document.form.apply_flag.value = 1;
		showLoading(5);
		setTimeout('location = "'+ location.pathname +'";', 5000);
		document.form.submit();
}

function save_table(){
	var rule_num = document.getElementById("qos_rulelist_table").rows.length;
	var item_num = document.getElementById("qos_rulelist_table").rows[0].cells.length;
	var tmp_value = "";
     var comp_tmp = "";

	for(i=0; i<rule_num; i++){
		tmp_value += "<"		
		for(j=0; j<item_num-1; j++){							
			if(j==5){
				tmp_value += document.getElementById("qos_rulelist_table").rows[i].cells[j].firstChild.value;
			}else{						
				if(document.getElementById("qos_rulelist_table").rows[i].cells[j].innerHTML.lastIndexOf("...")<0){
					tmp_value += document.getElementById("qos_rulelist_table").rows[i].cells[j].innerHTML;
				}else{
					tmp_value += document.getElementById("qos_rulelist_table").rows[i].cells[j].title;
				}
			}
			
			if(j != item_num-2)	
				tmp_value += ">";
		}
	}
	if(tmp_value == "<"+IPC_VSList_Norule || tmp_value == "<")
		tmp_value = "";	
	document.form.qos_rulelist.value = tmp_value;
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
		
	if((document.form.qos_max_transferred_x_0.value.length > 0) 
	   && (parseInt(document.form.qos_max_transferred_x_0.value) < parseInt(document.form.qos_min_transferred_x_0.value))){
				document.form.qos_max_transferred_x_0.focus();
				alert("<% tcWebApi_get("String_Entry", "vlaue_haigher_than", "s") %> "+document.form.qos_min_transferred_x_0.value);	
				return false;
	}
	
	return true;
}

function addRow_Group(upper){
	if(validForm()){
		var rule_num = document.getElementById("qos_rulelist_table").rows.length;
		var item_num = document.getElementById("qos_rulelist_table").rows[0].cells.length;	

		if(rule_num >= upper){
			alert("<%tcWebApi_get("String_Entry","JS_itemlimit1","s")%> " + upper + " <%tcWebApi_get("String_Entry","JS_itemlimit2","s")%>");
			return;	
		}			
		
		conv_to_transf();	
		if(item_num >=2){		//duplicate check: {IP/MAC, port, proto, transferred}
			for(i=0; i<rule_num; i++){
				if(overlib_str[i]){
					if(document.form.qos_ip_x_0.value == document.getElementById("qos_rulelist_table").rows[i].cells[1].innerHTML
						&& document.form.qos_port_x_0.value == overlib_str[i] 
						&& document.form.qos_transferred_x_0.value == document.getElementById("qos_rulelist_table").rows[i].cells[4].innerHTML){
						
							if(document.form.qos_proto_x_0.value == document.getElementById("qos_rulelist_table").rows[i].cells[3].innerHTML
								|| document.form.qos_proto_x_0.value == 'any'
								|| document.getElementById("qos_rulelist_table").rows[i].cells[3].innerHTML == 'any'){
										alert("<% tcWebApi_get("String_Entry","JS_duplicate","s") %>");
										parse_port="";
										document.form.qos_port_x_0.value =="";
										document.form.qos_ip_x_0.focus();
										document.form.qos_ip_x_0.select();
										return;
							}else if(document.form.qos_proto_x_0.value == document.getElementById("qos_rulelist_table").rows[i].cells[3].innerHTML
											|| (document.form.qos_proto_x_0.value == 'tcp/udp' && (document.getElementById("qos_rulelist_table").rows[i].cells[3].innerHTML == 'tcp' || document.getElementById("qos_rulelist_table").rows[i].cells[3].innerHTML == 'udp'))
											|| (document.getElementById("qos_rulelist_table").rows[i].cells[3].innerHTML == 'tcp/udp' && (document.form.qos_proto_x_0.value == 'tcp' || document.form.qos_proto_x_0.value == 'udp'))){
													alert("<% tcWebApi_get("String_Entry","JS_duplicate","s") %>");
													parse_port="";
													document.form.qos_port_x_0.value =="";
													document.form.qos_ip_x_0.focus();
													document.form.qos_ip_x_0.select();
													return;							
							}				
					}
				}else{
					if(document.form.qos_ip_x_0.value == document.getElementById("qos_rulelist_table").rows[i].cells[1].innerHTML 
						&& document.form.qos_port_x_0.value == document.getElementById("qos_rulelist_table").rows[i].cells[2].innerHTML
						&& document.form.qos_transferred_x_0.value == document.getElementById("qos_rulelist_table").rows[i].cells[4].innerHTML){
						
								if(document.form.qos_proto_x_0.value == document.getElementById("qos_rulelist_table").rows[i].cells[3].innerHTML
										|| document.form.qos_proto_x_0.value == 'any'
										|| document.getElementById("qos_rulelist_table").rows[i].cells[3].innerHTML == 'any'){
												alert("<% tcWebApi_get("String_Entry","JS_duplicate","s") %>");							
												parse_port="";
												document.form.qos_port_x_0.value =="";
												document.form.qos_ip_x_0.focus();
												document.form.qos_ip_x_0.select();
												return;
											
								}else if(document.form.qos_proto_x_0.value == document.getElementById("qos_rulelist_table").rows[i].cells[3].innerHTML
											|| (document.form.qos_proto_x_0.value == 'tcp/udp' && (document.getElementById("qos_rulelist_table").rows[i].cells[3].innerHTML == 'tcp' || document.getElementById("qos_rulelist_table").rows[i].cells[3].innerHTML == 'udp'))
											|| (document.getElementById("qos_rulelist_table").rows[i].cells[3].innerHTML == 'tcp/udp' && (document.form.qos_proto_x_0.value == 'tcp' || document.form.qos_proto_x_0.value == 'udp'))){
													alert("<% tcWebApi_get("String_Entry","JS_duplicate","s") %>");							
													parse_port="";
													document.form.qos_port_x_0.value =="";
													document.form.qos_ip_x_0.focus();
													document.form.qos_ip_x_0.select();
													return;
								}
					}						
				}	
			}
		}
	
		addRow(document.form.qos_service_name_x_0 ,1);
		addRow(document.form.qos_ip_x_0, 0);
		addRow(document.form.qos_port_x_0, 0);
		addRow(document.form.qos_proto_x_0, 0);
		document.form.qos_proto_x_0.value="tcp/udp";
		if(document.form.qos_transferred_x_0.value == "~")
			document.form.qos_transferred_x_0.value = "";
		addRow(document.form.qos_transferred_x_0, 0);
		addRow(document.form.qos_prio_x_0, 0);
		document.form.qos_prio_x_0.value="1";
		showqos_rulelist();
	}
}

function del_Row(r){
  var i=r.parentNode.parentNode.rowIndex;
  document.getElementById("qos_rulelist_table").deleteRow(i);
  
  var qos_rulelist_value = "";
	for(k=0; k<document.getElementById("qos_rulelist_table").rows.length; k++){
		for(j=0; j<document.getElementById("qos_rulelist_table").rows[k].cells.length-1; j++){
			if(j == 0)	
				qos_rulelist_value += "<";
			else
				qos_rulelist_value += ">";
				
			if(j == 5){
				qos_rulelist_value += document.getElementById("qos_rulelist_table").rows[k].cells[j].firstChild.value;
			}else if(document.getElementById("qos_rulelist_table").rows[k].cells[j].innerHTML.lastIndexOf("...")<0){	
				qos_rulelist_value += document.getElementById("qos_rulelist_table").rows[k].cells[j].innerHTML;	
			}else{
				qos_rulelist_value += document.getElementById("qos_rulelist_table").rows[k].cells[j].title;
			}
		}
	}
	
	qos_rulelist_array = qos_rulelist_value;
	if(qos_rulelist_array == "")
		showqos_rulelist();
}

function showqos_rulelist(){
	var qos_rulelist_row = "";
	qos_rulelist_row = decodeURIComponent(qos_rulelist_array).split('<');	

	var code = "";
	code +='<table width="100%"  border="1" align="center" cellpadding="4" cellspacing="0" class="list_table" id="qos_rulelist_table">';
	if(qos_rulelist_row.length == 1)	// no exist "<"
		code +='<tr><td style="color:#FFCC00;" colspan="10">'+IPC_VSList_Norule+'</td></tr>';
	else{
		for(var i = 1; i < qos_rulelist_row.length; i++){
			overlib_str0[i] ="";
			overlib_str[i] ="";			
			code +='<tr id="row'+i+'">';
			var qos_rulelist_col = qos_rulelist_row[i].split('>');
			var wid=[20, 19, 15, 13, 16, 11];						
				for(var j = 0; j < qos_rulelist_col.length; j++){
						if(j != 0 && j !=2 && j!=5){
							code +='<td width="'+wid[j]+'%">'+ qos_rulelist_col[j] +'</td>';
						}else if(j==0){
							if(qos_rulelist_col[0].length >15){
								overlib_str0[i] += qos_rulelist_col[0];
								qos_rulelist_col[0]=qos_rulelist_col[0].substring(0, 13)+"...";
								code +='<td width="'+wid[j]+'%"  title="'+overlib_str0[i]+'">'+ qos_rulelist_col[0] +'</td>';
							}else
								code +='<td width="'+wid[j]+'%">'+ qos_rulelist_col[j] +'</td>';
						}else if(j==2){
							if(qos_rulelist_col[2].length >13){
								overlib_str[i] += qos_rulelist_col[2];
								qos_rulelist_col[2]=qos_rulelist_col[2].substring(0, 11)+"...";
								code +='<td width="'+wid[j]+'%"  title="'+overlib_str[i]+'">'+ qos_rulelist_col[2] +'</td>';
							}else
								code +='<td width="'+wid[j]+'%">'+ qos_rulelist_col[j] +'</td>';																						
						}else if(j==5){
								code += '<td width="'+wid[j]+'%"><select class="input_option" style="width:85px;">';


								if(qos_rulelist_col[5] =="0")
									code += '<option value="0" selected><% tcWebApi_Get("String_Entry", "Highest", "s") %></option>';
								else
									code += '<option value="0"><% tcWebApi_Get("String_Entry", "Highest", "s") %></option>';

								if(qos_rulelist_col[5] =="1")
									code += '<option value="1" selected><% tcWebApi_Get("String_Entry", "High", "s") %></option>';
								else
									code += '<option value="1"><% tcWebApi_Get("String_Entry", "High", "s") %></option>';

								if(qos_rulelist_col[5] =="2")
									code += '<option value="2" selected><% tcWebApi_Get("String_Entry", "Medium", "s") %></option>';
								else
									code += '<option value="2"><% tcWebApi_Get("String_Entry", "Medium", "s") %></option>';

								if(qos_rulelist_col[5] =="3")
									code += '<option value="3" selected><% tcWebApi_Get("String_Entry", "Low", "s") %></option>';
								else
									code += '<option value="3"><% tcWebApi_Get("String_Entry", "Low", "s") %></option>';

								if(qos_rulelist_col[5] =="4")
									code += '<option value="4" selected><% tcWebApi_Get("String_Entry", "Lowest", "s") %></option>';
								else
									code += '<option value="4"><% tcWebApi_Get("String_Entry", "Lowest", "s") %></option>';

								code += '</select></td>';
						}
				}
				code +='<td  width="8%">';
				code +='<input class="remove_btn" type="button" onclick="del_Row(this);"/></td></tr>';
		}
	}
	code +='</table>';
	document.getElementById("qos_rulelist_Block").innerHTML = code;
	
	
	parse_port="";
}

function conv_to_transf(){
	if(document.form.qos_min_transferred_x_0.value =="" &&document.form.qos_max_transferred_x_0.value =="")
		document.form.qos_transferred_x_0.value = "";
	else
		document.form.qos_transferred_x_0.value = document.form.qos_min_transferred_x_0.value + "~" + document.form.qos_max_transferred_x_0.value;
}

function switchPage(page){
	
	if(page == "1")
		location.href = "QoS_EZQoS.asp";
	else if(page == "2")
		location.href = "Advanced_QOSUserPrio_Content.asp";	
	else
		return false;		
}

function validate_multi_port(val, min, max){
	for(i=0; i<val.length; i++)
	{
		if (val.charAt(i)<'0' || val.charAt(i)>'9')
		{
		alert('<% tcWebApi_Get("String_Entry", "BM_alert_port1", "s") %> ' + min + ' <% tcWebApi_Get("String_Entry", "BM_alert_to", "s") %> ' + max);
			return false;
		}
		if(val<min || val>max) {
			alert('<% tcWebApi_Get("String_Entry", "BM_alert_port1", "s") %> ' + min + ' <% tcWebApi_Get("String_Entry", "BM_alert_to", "s") %> ' + max);
			return false;
		}else{
			val = str2val(val);
			if(val=="")
				val="0";
			return true;
		}						
	}	
}
function validate_multi_range(val, mini, maxi){
	var rangere=new RegExp("^([0-9]{1,5})\:([0-9]{1,5})$", "gi");
	if(rangere.test(val)){
		
		if(!validate_each_port(document.form.qos_port_x_0, RegExp.$1, mini, maxi) || !validate_each_port(document.form.qos_port_x_0, RegExp.$2, mini, maxi)){
				return false;								
		}else if(parseInt(RegExp.$1) >= parseInt(RegExp.$2)){
				alert(val + "<% tcWebApi_Get("String_Entry", "JS_validport", "s") %>");	
				return false;												
		}else				
			return true;	
	}else{
		if(!validate_single_range(val, mini, maxi)){	
					return false;											
				}
				return true;								
			}	
	}

function validate_single_range(val, min, max) {
	for(j=0; j<val.length; j++){		//is_number
		if (val.charAt(j)<'0' || val.charAt(j)>'9'){			
			alert('<% tcWebApi_Get("String_Entry", "BM_alert_port1", "s") %> ' + min + ' <% tcWebApi_Get("String_Entry", "BM_alert_to", "s") %> ' + max);
			return false;
		}
	}
	
	if(val < min || val > max) {		//is_in_range		
		alert('<% tcWebApi_Get("String_Entry", "BM_alert_port1", "s") %> ' + min + ' <% tcWebApi_Get("String_Entry", "BM_alert_to", "s") %> ' + max);
		return false;
	}else	
		return true;
	}		

var parse_port="";
function Check_multi_range(obj, mini, maxi){	
	obj.value = document.form.qos_port_x_0.value.replace(/[-~]/gi,":");	// "~-" to ":"
	var PortSplit = obj.value.split(",");			
	for(i=0;i<PortSplit.length;i++){
		PortSplit[i] = PortSplit[i].replace(/(^\s*)|(\s*$)/g, ""); 		// "\space" to ""
		PortSplit[i] = PortSplit[i].replace(/(^0*)/g, ""); 		// "^0" to ""	
				
		if(!validate_multi_range(PortSplit[i], mini, maxi)){
			obj.focus();
			obj.select();
			return false;
		}						
		
		if(i ==PortSplit.length -1)
			parse_port = parse_port + PortSplit[i];
		else
			parse_port = parse_port + PortSplit[i] + ",";
			
	}
	document.form.qos_port_x_0.value = parse_port;
	return true;	
}

// Viz add 2011.06 Load default qos rule from XML
var url_link = "ajax_qos_default.xml";
function load_QoS_rule(){		
	free_options(document.form.qos_default_sel);
	//add_option(document.form.qos_default_sel, "<% tcWebApi_Get("String_Entry", "Select_menu_default", "s") %>", 0, 1);	
	loadXMLDoc(url_link);		
}

var xmlhttp;
function loadXMLDoc(url_link){
	var ie = window.ActiveXObject;
	if (ie){		//IE
		xmlhttp = new ActiveXObject("Microsoft.XMLDOM");
		xmlhttp.async = false;
  		if (xmlhttp.readyState==4){
			xmlhttp.load(url_link);
			Load_XML2form();
		}								
	}else{	// FF Chrome Safari...
  		xmlhttp=new XMLHttpRequest();
  		if (xmlhttp.overrideMimeType){
			xmlhttp.overrideMimeType('text/xml');
		}			
		xmlhttp.onreadystatechange = alertContents_qos;	
		xmlhttp.open("GET",url_link,true);
		xmlhttp.send();		
	}					
}

function alertContents_qos()
{
	if (xmlhttp != null && xmlhttp.readyState != null && xmlhttp.readyState == 4){
		if (xmlhttp.status != null && xmlhttp.status == 200){
				Load_XML2form();
		}
	}
}

// Load XML to Select option & save all info
var QoS_rules;
var Sel_desc, Sel_port, Sel_proto, Sel_rate, Sel_prio;
var rule_desc = new Array();
var rule_port = new Array();
var rule_proto = new Array();
var rule_rate = new Array();
var rule_prio = new Array();
function Load_XML2form(){			
			
			if (window.ActiveXObject){		//IE			
				QoS_rules = xmlhttp.getElementsByTagName("qos_rule");
			}else{	// FF Chrome Safari...
				QoS_rules = xmlhttp.responseXML.getElementsByTagName("qos_rule");
			}
				
			for(i=0;i<QoS_rules.length;i++){
				Sel_desc=QoS_rules[i].getElementsByTagName("desc");
				Sel_port=QoS_rules[i].getElementsByTagName("port");
				Sel_proto=QoS_rules[i].getElementsByTagName("proto");
				Sel_rate=QoS_rules[i].getElementsByTagName("rate");
				Sel_prio=QoS_rules[i].getElementsByTagName("prio");
 
				add_option(document.form.qos_default_sel, Sel_desc[0].firstChild.nodeValue, i, 0);				

				if(Sel_desc[0].firstChild != null)
					rule_desc[i] = Sel_desc[0].firstChild.nodeValue;					
				else
					rule_desc[i] ="";
					
				if(Sel_port[0].firstChild != null)						
					rule_port[i] = Sel_port[0].firstChild.nodeValue;
				else
					rule_port[i] ="";
				
				if(Sel_proto[0].firstChild != null)
					rule_proto[i] = Sel_proto[0].firstChild.nodeValue;
				else
					rule_proto[i] ="";	
				
				if(Sel_rate[0].firstChild != null)
					rule_rate[i] = Sel_rate[0].firstChild.nodeValue;
				else
					rule_rate[i] ="";	
					
				if(Sel_prio[0].firstChild != null)
					rule_prio[i] = Sel_prio[0].firstChild.nodeValue;
				else
					rule_prio[i] ="";	
			}	
	showQoSList();
}

//Viz add 2011.06 change qos_sel
function change_wizard(obj){
		for(var j = 0; j < QoS_rules.length; j++){
			if(rule_desc[j] != null && obj.value == j){

				if(rule_proto[j] == "TCP")
					document.form.qos_proto_x_0.options[0].selected = 1;
				else if(rule_proto[j] == "UDP")
					document.form.qos_proto_x_0.options[1].selected = 1;
				else if(rule_proto[j] == "TCP/UDP")
					document.form.qos_proto_x_0.options[2].selected = 1;
				else if(rule_proto[j] == "ANY")
					document.form.qos_proto_x_0.options[3].selected = 1;
				/*	marked By Viz 2011.12 for "iptables -p"
				else if(rule_proto[j] == "ICMP")
					document.form.qos_proto_x_0.options[3].selected = 1;
				else if(rule_proto[j] == "IGMP")
					document.form.qos_proto_x_0.options[4].selected = 1;	*/
				else
					document.form.qos_proto_x_0.options[0].selected = 1;
				
				if(rule_prio[j] == "<% tcWebApi_Get("String_Entry", "Highest", "s") %>")
					document.form.qos_prio_x_0.options[0].selected = 1;
				else if(rule_prio[j] == "<% tcWebApi_Get("String_Entry", "High", "s") %>")
					document.form.qos_prio_x_0.options[1].selected = 1;
				else if(rule_prio[j] == "<% tcWebApi_Get("String_Entry", "Medium", "s") %>")
					document.form.qos_prio_x_0.options[2].selected = 1;
				else if(rule_prio[j] == "<% tcWebApi_Get("String_Entry", "Low", "s") %>")
					document.form.qos_prio_x_0.options[3].selected = 1;
				else if(rule_prio[j] == "<% tcWebApi_Get("String_Entry", "Lowest", "s") %>")
					document.form.qos_prio_x_0.options[4].selected = 1;	
				else
					document.form.qos_prio_x_0.options[2].selected = 1;
				
				if(rule_rate[j] == ""){
					document.form.qos_min_transferred_x_0.value = "";
					document.form.qos_max_transferred_x_0.value = "";
				}else{
					var trans=rule_rate[j].split("~");
					document.form.qos_min_transferred_x_0.value = trans[0];
					document.form.qos_max_transferred_x_0.value = trans[1];
				}	
				
				
				document.form.qos_service_name_x_0.value = rule_desc[j];
				document.form.qos_port_x_0.value = rule_port[j];
				break;
			}
		}
}

/*------------ Mouse event of fake LAN IP select menu {-----------------*/
function setClientIP(j){
	document.form.qos_service_name_x_0.value = rule_desc[j];

	if(rule_rate[j] == ""){
		document.form.qos_min_transferred_x_0.value = "";
		document.form.qos_max_transferred_x_0.value = "";
	}
	else{
		var trans=rule_rate[j].split("~");
		document.form.qos_min_transferred_x_0.value = trans[0];
		document.form.qos_max_transferred_x_0.value = trans[1];
	}	
	
	if(rule_proto[j] == "TCP")
		document.form.qos_proto_x_0.options[0].selected = 1;
	else if(rule_proto[j] == "UDP")
		document.form.qos_proto_x_0.options[1].selected = 1;
	else if(rule_proto[j] == "TCP/UDP")
		document.form.qos_proto_x_0.options[2].selected = 1;
	else if(rule_proto[j] == "ANY")
		document.form.qos_proto_x_0.options[3].selected = 1;
	/* marked By Viz 2011.12 for "iptables -p"
	else if(rule_proto[j] == "ICMP")
		document.form.qos_proto_x_0.options[3].selected = 1;
	else if(rule_proto[j] == "IGMP")
		document.form.qos_proto_x_0.options[4].selected = 1;	*/	
	else
		document.form.qos_proto_x_0.options[0].selected = 1;

	if(rule_prio[j] == "Highest")
		document.form.qos_prio_x_0.options[0].selected = 1;
	else if(rule_prio[j] == "High")
		document.form.qos_prio_x_0.options[1].selected = 1;
	else if(rule_prio[j] == "Medium")
		document.form.qos_prio_x_0.options[2].selected = 1;
	else if(rule_prio[j] == "Low")
		document.form.qos_prio_x_0.options[3].selected = 1;
	else if(rule_prio[j] == "Lowest")
		document.form.qos_prio_x_0.options[4].selected = 1;	
	else
		document.form.qos_prio_x_0.options[2].selected = 1;

	document.form.qos_service_name_x_0.value = rule_desc[j];
	document.form.qos_port_x_0.value = rule_port[j];

	hideClients_Block();
}

function showQoSList(){
	var code = "";
		
	for(var i = 0; i < rule_desc.length; i++){
		if(rule_port[i] == 0000)
			code +='<a><div ><dt><strong>'+rule_desc[i]+'</strong></dt></div></a>';
		else
			code += '<a><div onclick="setClientIP('+i+');"><dd>'+rule_desc[i]+'</dd></div></a>';
	}
	code +='<!--[if lte IE 6.5]><iframe class="hackiframe2"></iframe><![endif]-->';	
	document.getElementById("QoSList_Block").innerHTML = code;
}

var isMenuopen = 0;
function pullQoSList(obj){
	if(isMenuopen == 0){
		obj.src = "/images/arrow-top.gif"
		document.getElementById("QoSList_Block").style.display = 'block';
		//document.form.qos_service_name_x_0.focus();		
		isMenuopen = 1;
	}
	else{
		document.getElementById("pull_arrow").src = "/images/arrow-down.gif";
		document.getElementById("QoSList_Block").style.display="none";
		isMenuopen = 0;
	}
}

function hideClients_Block(evt){
	if(typeof(evt) != "undefined"){
		if(!evt.srcElement)
			evt.srcElement = evt.target; // for Firefox

		if(evt.srcElement.id == "pull_arrow" || evt.srcElement.id == "QoSList_Block"){
			return;
		}
	}

	document.getElementById("pull_arrow").src = "/images/arrow-down.gif";
	document.getElementById("QoSList_Block").style.display="none";
	isMenuopen = 0;
}
/*----------} Mouse event of fake LAN IP select menu-----------------*/

//Viz add 2011.11 for replace ">" to ":65535"   &   "<" to "1:"  {
function replace_symbol(){	
					var largre_src=new RegExp("^(>)([0-9]{1,5})$", "gi");
					if(largre_src.test(document.form.qos_port_x_0.value)){
						document.form.qos_port_x_0.value = document.form.qos_port_x_0.value.replace(/[>]/gi,"");	// ">" to ""
						document.form.qos_port_x_0.value = document.form.qos_port_x_0.value+":65535"; 						// add ":65535"
					}
					var smalre_src=new RegExp("^(<)([0-9]{1,5})$", "gi");
					if(smalre_src.test(document.form.qos_port_x_0.value)){
						document.form.qos_port_x_0.value = document.form.qos_port_x_0.value.replace(/[<]/gi,"");	// "<" to ""
						document.form.qos_port_x_0.value = "1:"+document.form.qos_port_x_0.value; 						// add "1:"						
					}		
}					
//} Viz add 2011.11 for replace ">" to ":65535"   &   "<" to "1:" 

function valid_IPorMAC(obj){
	
	if(obj.value == ""){
			return true;
	}else{
			var hwaddr = new RegExp("(([a-fA-F0-9]{2}(\:|$)){6})", "gi");		// ,"g" whole erea match & "i" Ignore Letter
			var legal_hwaddr = new RegExp("(^([a-fA-F0-9][cC048])(\:))", "gi"); // for legal MAC, unicast & globally unique (OUI enforced)

			if(obj.value.split(":").length >= 2){
					if(!hwaddr.test(obj.value)){	
							obj.focus();
							alert("<% tcWebApi_Get("String_Entry", "LHC_MnlDHCPMacaddr_id","s") %>");							
    					return false;
    			}else if(!legal_hwaddr.test(obj.value)){
    					obj.focus();
						alert("<% tcWebApi_Get("String_Entry", "IPC_x_illegal_mac","s") %>");
    					return false;
    			}else
    					return true;
			}		
			else if(obj.value.split("*").length >= 2){
					if(!valid_IP_subnet(obj))
							return false;
					else
							return true;				
			}
			else if(!valid_IP_form(obj, 0)){
    			return false;
			}
			else
					return true;		
	}	
}

</script>
</head>

<body onkeydown="key_event(event);" onclick="if(isMenuopen){hideClients_Block(event)}" onLoad="initial();" onunLoad="return unload_body();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<form method="post" name="form" id="ruleForm" action="/start_apply.htm" target="hidden_frame">
<input type="hidden" name="current_page" value="Advanced_QOSUserRules_Content.asp">
<input type="hidden" name="next_page" value="">
<input type="hidden" name="next_host" value="">
<input type="hidden" name="modified" value="0">
<input type="hidden" name="action_mode" value="apply">
<input type="hidden" name="action_wait" value="5">
<input type="hidden" name="action_script" value="restart_qos">
<input type="hidden" name="first_time" value="">
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% tcWebApi_get("SysInfo_Entry","preferred_lang","s") %>">
<input type="hidden" name="firmver" value="<% tcWebApi_get("SysInfo_Entry","FWVer","s") %>">
<input type="hidden" name="qos_rulelist" value='<% tcWebApi_get("QoS_Entry0", "qos_rulelist", "s") %>'>
<!--input type="hidden" name="qos_enable_orig" value="<% tcWebApi_get("QoS_Entry0", "qos_enable", "s") %>">
<input type="hidden" name="qos_enable" value="1"-->

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
		<td valign="top" >
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
							<option value="2"><% tcWebApi_Get("String_Entry", "qos_user_prio", "s") %></option>
							<option value="3" selected><% tcWebApi_Get("String_Entry", "qos_user_rules", "s") %></option>
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
					<td>
		  			<div id="is_qos_enable_desc" class="formfontdesc" style="font-style: italic;font-size: 14px;color:#FFCC00;">
					<ul>
						<li><% tcWebApi_Get("String_Entry", "UserQoSRule_desc_zero", "s") %></li>
						<li><% tcWebApi_Get("String_Entry", "UserQoSRule_desc_one", "s") %></li>
					</ul>
					</div>
					<div class="formfontdesc">
						<a id="faq" style="text-decoration:underline;" href="https://www.asus.com/support/FAQ/1010951/" target="_blank">QoS FAQ</a>
					</div>
					</td>
					</tr>
					<tr>
					<td>
						<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable_table" style="margin-top:8px">
							<thead>
							<tr>
								<td colspan="4" id="TriggerList" style="border-right:none;"><% tcWebApi_Get("String_Entry", "BM_UserList_title", "s") %> (<% tcWebApi_Get("String_Entry", "List_limit", "s") %> 32)</td>
								<td colspan="3" id="TriggerList" style="border-left:none;">
									<div style="margin-top:0px;display:none" align="right">
										<select id='qos_default_sel' name='qos_default_sel' class="input_option" onchange="change_wizard(this);"></select>
									</div>
								</td>
							</tr>
							</thead>
			
							<tr>
								<th><% tcWebApi_Get("String_Entry", "BM_UserList1", "s") %></th>
								<th><a href="javascript:void(0);" onClick="openHint(18,6);"><div class="table_text"><% tcWebApi_Get("String_Entry", "BM_UserList2", "s") %></div></a></th>
								<th><a href="javascript:void(0);" onClick="openHint(18,4);"><div class="table_text"><% tcWebApi_Get("String_Entry", "BM_UserList3", "s") %></div></a></th>
								<th><div class="table_text"><% tcWebApi_Get("String_Entry", "IPC_VServerProto_in", "s") %></div></th>
								<th><a href="javascript:void(0);" onClick="openHint(18,5);"><div class="table_text"><div class="table_text"><% tcWebApi_Get("String_Entry", "UserQoS_transferred", "s") %></div></a></th>
								<th><% tcWebApi_Get("String_Entry", "BM_UserList4", "s") %></th>
								<th><% tcWebApi_Get("String_Entry", "list_add_delete", "s") %></th>
							</tr>							
							<tr>
								<td width="20%">							
									<input type="text" class="input_12_table" maxlength="20" style="float:left;width:105px;" placeholder="<% tcWebApi_Get("String_Entry", "Select_menu_default", "s") %>" name="qos_service_name_x_0" onKeyPress="return validator.isString(this, event)">
									<img id="pull_arrow" height="14px;" src="/images/arrow-down.gif" onclick="pullQoSList(this);" title="<% tcWebApi_Get("String_Entry", "select_service", "s") %>" >
									<div id="QoSList_Block" class="QoSList_Block" onclick="hideClients_Block()"></div>
								</td>
								<td width="19%"><input type="text" maxlength="17" class="input_15_table" name="qos_ip_x_0" style="width:125px;"></td>
								<td width="15%"><input type="text" class="input_12_table" maxlength="64" name="qos_port_x_0" onKeyPress="return validator.isPortRange(this, event)"></td>
								<td width="13%">
									<select name='qos_proto_x_0' class="input_option" style="width:75px;">
										<option value='tcp'>TCP</option>
										<option value='udp'>UDP</option>
										<option value='tcp/udp' selected>TCP/UDP</option>
										<option value='any'>ANY</option>
										<!--	marked By Viz 2011.12 for "iptables -p"
										option value='icmp'>ICMP</option>
										<option value='igmp'>IGMP</option -->
									</select>
								</td>
								<td width="16%">
									<input type="text" class="input_3_table" maxlength="7" onKeyPress="return validator.isNumber(this,event);" onblur="conv_to_transf();" name="qos_min_transferred_x_0">~
									<input type="text" class="input_3_table" maxlength="7" onKeyPress="return validator.isNumber(this,event);" onblur="conv_to_transf();" name="qos_max_transferred_x_0"> KB
									<input type="hidden" name="qos_transferred_x_0" value="">
								</td>
								<td width="11%">
									<select name='qos_prio_x_0' class="input_option" style="width:87px;"> <!--style="width:auto;"-->
										<option value='0'><% tcWebApi_Get("String_Entry", "Highest", "s") %></option>
										<option value='1' selected><% tcWebApi_Get("String_Entry", "High", "s") %></option>
										<option value='2'><% tcWebApi_Get("String_Entry", "Medium", "s") %></option>
										<option value='3'><% tcWebApi_Get("String_Entry", "Low", "s") %></option>
										<option value='4'><% tcWebApi_Get("String_Entry", "Lowest", "s") %></option>
									</select>
								</td>
								
								<td width="8%">
									<input type="button" class="add_btn" onClick="addRow_Group(32);">
								</td>
							</tr>
							</table>
							<div id="qos_rulelist_Block"></div>
							</td>							
						</tr>
						<!--tr><td>
							<div id="qos_rulelist_Block"></div>
						</td></tr-->
						<tr><td>
							<div class="apply_gen">
								<input type="hidden" name="apply_flag" value="0">
								<input name="button" type="button" class="button_gen" onClick="applyRule()" value="<%tcWebApi_get("String_Entry","CTL_apply","s")%>"/>
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
