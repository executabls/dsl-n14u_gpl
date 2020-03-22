<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>

<!--aidisk/popCreateFolder.asp-->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<link rel="shortcut icon" href="/images/favicon.png">
<link rel="icon" href="/images/favicon.png">
<title>Add New Folder</title>
<link rel="stylesheet" href="/form_style.css" type="text/css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript">
var PoolDevice = parent.pool_devices()[parent.getSelectedPoolOrder()];
var PoolName = parent.pool_names()[parent.getSelectedPoolOrder()];
var folderlist = parent.get_sharedfolder_in_pool(PoolDevice);
function initial(){
	showtext(document.getElementById("poolName"), PoolName);
	clickevent();
}
function clickevent(){
	$("Submit").onclick = function(){
		if(validForm()){
			if(parent.get_manage_type(parent.document.aidiskForm.protocol.value) == 1)
				document.createFolderForm.account.value = parent.getSelectedAccount();
			else
				document.createFolderForm.account.disabled = 1;
			document.createFolderForm.pool.value = PoolDevice;
			/*alert('action = '+document.createFolderForm.action+'\n'+
			'account = '+document.createFolderForm.account.value+'\n'+
			'pool = '+document.createFolderForm.pool.value+'\n'+
			'folder = '+document.createFolderForm.folder.value
			);//*/
			parent.showLoading();
			document.createFolderForm.submit();
			parent.hidePop("apply");//*/
		}
	};
}
function validForm(){
	$("folder").value = trim($("folder").value);
	if($("folder").value.length == 0){
		alert("<%tcWebApi_get("String_Entry","File_content_alert_desc6","s")%>");
		$("folder").focus();
		return false;
	}
	var re = new RegExp("[^a-zA-Z0-9 _-]+", "gi");
	if(re.test($("folder").value)){
		alert("<%tcWebApi_get("String_Entry","File_content_alert_desc7","s")%>");
		$("folder").focus();
		return false;
	}
	if(parent.checkDuplicateName($("folder").value, folderlist)){
		alert("<%tcWebApi_get("String_Entry","File_content_alert_desc8","s")%>");
		$("folder").focus();
		return false;
	}
	if(trim($("folder").value).length > 12)
		if (!(confirm("<%tcWebApi_get("String_Entry","File_content_alert_desc10","s")%>")))
			return false;
	return true;
}
</script>
</head>
<body onLoad="initial();">
<form name="createFolderForm" method="post" action="create_sharedfolder.asp" target="hidden_frame">
<input type="hidden" name="account" id="account">
<input type="hidden" name="pool" id="pool">
<table width="100%" class="popTable" border="0" align="center" cellpadding="0" cellspacing="0">
	<thead>
		<tr>
		<td colspan="2"><span style="color:#FFF"><%tcWebApi_get("String_Entry","AddFolderTitle","s")%> <%tcWebApi_get("String_Entry","in","s")%> </span><span style="color:#FFF" id="poolName"></span><img src="/images/button-close.gif" onClick="parent.hidePop('OverlayMask');"></td>
		</tr>
	</thead>
	<tbody>
		<tr align="center">
      <td height="50" colspan="2"><%tcWebApi_get("String_Entry","AddFolderAlert","s")%></td>
		</tr>
		<tr>
      <th width="100"><%tcWebApi_get("String_Entry","FolderName","s")%>: </th>
			<td height="50"><input class="input_25_table" type="text" name="folder" id="folder" style="width:220px;"></td>
		</tr>
		<tr bgcolor="#E6E6E6">
      <th colspan="2"><input id="Submit" type="button" class="button_gen" value="<%tcWebApi_get("String_Entry","CTL_add","s")%>"></th>
		</tr>
	</tbody>
</table>
</form>
</body>

<!--aidisk/popCreateFolder.asp-->
</html>

