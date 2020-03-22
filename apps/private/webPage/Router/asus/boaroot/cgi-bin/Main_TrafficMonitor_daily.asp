<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">

<title>ASUS <% tcWebApi_get("String_Entry","Web_Title2","s") %> <% tcWebApi_get("SysInfo_Entry","ProductTitle","s") %> - <%tcWebApi_get("String_Entry","menu4_2_3","s")%></title>
<link rel="stylesheet" type="text/css" href="/index_style.css"> 
<link rel="stylesheet" type="text/css" href="/form_style.css">
<link rel="stylesheet" type="text/css" href="/tmmenu.css">
<link rel="shortcut icon" href="/images/favicon.png">
<link rel="icon" href="/images/favicon.png">
<script language="JavaScript" type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script language="JavaScript" type="text/javascript" src="/general.js"></script>
<script language="JavaScript" type="text/javascript" src="/tmmenu.js"></script>
<script language="JavaScript" type="text/javascript" src="/tmhist.js"></script>
<script language="JavaScript" type="text/javascript" src="/popup.js"></script>
<script type='text/javascript'>

wan_route_x = '';
wan_nat_x = '1';
wan_proto = 'pppoe';

nvram = {
	wan_ifname: '',
	lan_ifname: 'br0',
	rstats_enable: '1',
	http_id: 'TIDe855a6487043d70a'};

try {
	<% tcWebApi_UpdateBandwidth("daily"); %>
}
catch (ex) {
	daily_history = [];
}
rstats_busy = 0;
if (typeof(daily_history) == 'undefined') {
	daily_history = [];
	rstats_busy = 1;
}

function save()
{
	cookie.set('daily', scale, 31);
}

function genData()
{
	var w, i, h, t;

	w = window.open('', 'tomato_data_d');
	w.document.writeln('<pre>');
	for (i = 0; i < daily_history.length-1; ++i) {
		h = daily_history[i];
		t = getYMD(h[0]);
		w.document.writeln([t[0], t[1] + 1, t[2], h[1], h[2]].join(','));
	}
	w.document.writeln('</pre>');
	w.document.close();
}

function getYMD(n)
{
	// [y,m,d]
	return [(((n >> 16) & 0xFF) + 1900), ((n >>> 8) & 0xFF), (n & 0xFF)];
}

function redraw()
{
	var h;
	var grid;
	var rows;
	var ymd;
	var d;
	var lastt;
	var lastu, lastd;

	if (daily_history.length-1 > 0) {
		ymd = getYMD(daily_history[0][0]);
		d = new Date((new Date(ymd[0], ymd[1], ymd[2], 12, 0, 0, 0)).getTime() - ((30 - 1) * 86400000));
		E('last-dates').innerHTML = '(' + ymdText(ymd[0], ymd[1], ymd[2]) + ' ~ ' + ymdText(d.getFullYear(), d.getMonth(), d.getDate()) + ')';

		lastt = ((d.getFullYear() - 1900) << 16) | (d.getMonth() << 8) | d.getDate();
	}

	lastd = 0;
	lastu = 0;
	rows = 0;
	block = '';
	gn = 0;

	grid = '<table width="730px" class="FormTable_NWM">'; 
	grid += "<tr><th style=\"height:30px;\"><%tcWebApi_get("String_Entry","Date","s")%></th>";
	grid += "<th><%tcWebApi_get("String_Entry","tm_reception","s")%></th>";
	grid += "<th><%tcWebApi_get("String_Entry","tm_transmission","s")%></th>";
	grid += "<th><%tcWebApi_get("String_Entry","Total","s")%></th></tr>";
	
	for (i = 0; i < daily_history.length-1; ++i) {
		h = daily_history[i];
		ymd = getYMD(h[0]);
		grid += makeRow(((rows & 1) ? 'odd' : 'even'), ymdText(ymd[0], ymd[1], ymd[2]), rescale(h[1]), rescale(h[2]), rescale(h[1] + h[2]));
		++rows;

		if (h[0] >= lastt) {
			lastd += h[1];
			lastu += h[2];
		}
	}
	
	if(rows == 0)
		grid +='<tr><td style="color:#FFCC00;" colspan="4"><%tcWebApi_get("String_Entry","IPC_VSList_Norule","s")%></td></tr>';

	E('bwm-daily-grid').innerHTML = grid + '</table>';	
	E('last-dn').innerHTML = rescale(lastd);
	E('last-up').innerHTML = rescale(lastu);
	E('last-total').innerHTML = rescale(lastu + lastd);
}

function init()
{
	var s;

	if (nvram.rstats_enable != '1') return;

	if ((s = cookie.get('daily')) != null) {
		if (s.match(/^([0-2])$/)) {
			E('scale').value = scale = RegExp.$1 * 1;
		}
	}

	initDate('ymd');
	daily_history.sort(cmpHist);
	redraw();
}

function switchPage(page){
	if(page == "1")
		location.href = "Main_TrafficMonitor_realtime.asp";
	else if(page == "2")
		location.href = "Main_TrafficMonitor_last24.asp";
	else
		return false;
}

</script>
</head>

<body onload="show_menu();init();" >

<div id="TopBanner"></div>

<div id="Loading" class="popup_bg"></div>

<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<form method="post" name="form" action="apply.cgi" target="hidden_frame">
<input type="hidden" name="current_page" value="Main_TrafficMonitor_daily.asp">
<input type="hidden" name="next_page" value="Main_TrafficMonitor_daily.asp">
<input type="hidden" name="next_host" value="">
<input type="hidden" name="group_id" value="">
<input type="hidden" name="modified" value="0">
<input type="hidden" name="action_mode" value="">
<input type="hidden" name="action_wait" value="">
<input type="hidden" name="action_script" value="">
<input type="hidden" name="first_time" value="">
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% tcWebApi_get("SysInfo_Entry","preferred_lang","s") %>">
<input type="hidden" name="firmver" value="<% tcWebApi_get("DeviceInfo","FwVer","s") %>">

<table class="content" align="center" cellpadding="0" cellspacing="0">
<tr>
	<td width="23">&nbsp;</td>

<!--=====Beginning of Main Menu=====-->
	<td valign="top" width="202">
	 	<div id="mainMenu"></div>
	 	<div id="subMenu"></div>
	</td>
		
    	<td valign="top">
		<div id="tabMenu" class="submenuBlock"></div>
<!--===================================Beginning of Main Content===========================================-->
      	<table width="98%" border="0" align="left" cellpadding="0" cellspacing="0">
	 	<tr>
         		<td align="left"  valign="top">           
				<table width="100%" border="0" cellpadding="4" cellspacing="0" class="FormTitle" id="FormTitle">		
				<tbody>	
				<!--===================================Beginning of QoS Content===========================================-->
	      		<tr>
	      			<td bgcolor="#4D595D" valign="top">
	      				<table width="740px" border="0" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3">
						<tr><td><table width=100%" >
        			<tr>

						<td  class="formfonttitle" align="left">								
							<div style="margin-top:5px;"><%tcWebApi_get("String_Entry","Menu_TrafficManager","s")%> - <%tcWebApi_get("String_Entry","traffic_monitor","s")%></div>
						</td>

						<td>
							<div align="right">
								<select class="input_option" style="width:120px" onchange="switchPage(this.options[this.selectedIndex].value)">
										<option value="1"><%tcWebApi_get("String_Entry","menu4_2_1","s")%></option>
										<option value="2"><%tcWebApi_get("String_Entry","menu4_2_2","s")%></option>
										<option value="3" selected><%tcWebApi_get("String_Entry","menu4_2_3","s")%></option>
								</select>
							</div>
						</td>
        			</tr>
					</table></td></tr>

        			<tr>
          				<td height="5"><img src="/images/New_ui/export/line_export.png" /></td>
        			</tr>
						<tr>
							<td bgcolor="#4D595D">
								<table width="730"  border="1" align="left" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
									<thead>
										<tr>
											<td colspan="2"><%tcWebApi_get("String_Entry","t2BC","s")%></td>
										</tr>
									</thead>
									<tbody>
										<tr class='even'>
											<th width="40%"><%tcWebApi_get("String_Entry","Date","s")%></th>
											<td>
												<select class="input_option" style="width:130px" onchange='changeDate(this, "ymd")' id='dafm'>
													<option value=0>yyyy-mm-dd</option>
													<option value=1>mm-dd-yyyy</option>
													<option value=2>mm, dd, yyyy</option>
													<option value=3>dd.mm.yyyy</option>
												</select>
											</td>
										</tr>
										<tr class='even'>
											<th width="40%"><%tcWebApi_get("String_Entry","Scale","s")%></th>
											<td>
												<select style="width:70px" class="input_option" onchange='changeScale(this)' id='scale'>
													<option value=0>KB</option>
													<option value=1>MB</option>
													<option value=2 selected>GB</option>
												</select>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<tr >
							<td>		
								<div id='bwm-daily-grid' style='float:left'></div>
							</td>
						</tr>

	     					<tr >
	      					<td bgcolor="#4D595D">
	      						<table width="730"  border="1" align="left" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >
	      						<thead>	
	      						<tr>
	      							<td colspan="2" id="TriggerList" style="text-align:left;"><%tcWebApi_get("String_Entry","Last30days","s")%> <span style="color:#FFF;background-color:transparent;" id='last-dates'></span></td>
	      						</tr>
	      						</thead>
	      	      				<tbody>
	      						<tr class='even'><th width="40%"><%tcWebApi_get("String_Entry","tm_reception","s")%></th><td id='last-dn'>-</td></tr>
	      						<tr class='odd'><th width="40%"><%tcWebApi_get("String_Entry","tm_transmission","s")%></th><td id='last-up'>-</td></tr>
	      						<tr class='footer'><th width="40%"><%tcWebApi_get("String_Entry","Total","s")%></th><td id='last-total'>-</td></tr>
	      						</tbody>	
	      						</table>
	      					</td>
	     					</tr>
	     					</table>
	     				</td>
	     			</tr>		
				</tbody>
				</table>
			</td>
		</tr>
		</table>				
		</div>
	</td>
		
    	<td width="10" align="center" valign="top">&nbsp;</td>
</tr>
</table>
<div id="footer"></div>
</body>
</html>

