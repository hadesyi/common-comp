<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
 /**
  * @Class Name : EgovPrivacyLogList.jsp
  * @Description : 개인정보조회 로그 정보목록 화면
  * @Modification Information
  * @
  * @  수정일         수정자          수정내용
  * @ -------        --------    ---------------------------
  * @ 2014.09.11      표준프레임워크          최초 생성
  *  @author Vincent Han
  *  @since 2014.09.11
  *  @version 3.5
  */
%>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="<c:url value='/css/egovframework/com/com.css' />" rel="stylesheet" type="text/css">
<link href="<c:url value='/css/egovframework/com/button.css' />" rel="stylesheet" type="text/css">
<script type="text/javascript" src="<c:url value='/js/egovframework/com/sym/cal/EgovCalPopup.js'/>" ></script>
<script type="text/javascript">

	function fn_egov_select_privacyLog(pageNo){
		var fromDate = document.frm.searchBeginDate.value;
		var toDate = document.frm.searchEndDate.value;

		if (fromDate > toDate) {
	        alert("종료일자는 시작일자보다  이후날짜로 선택하세요.");
	        //return false;
	    } else {
			document.frm.pageIndex.value = pageNo;
			document.frm.action = "<c:url value='/sym/log/plg/SelectPrivacyLogList.do'/>";
			document.frm.submit();
	    }
	}

	function fn_egov_inqire_privacyLog(requestId){
		var url = "<c:url value='/sym/log/plg/InqirePrivacyLog.do' />?requestId="+requestId;

		var openParam = "scrollbars=yes,toolbar=0,location=no,resizable=0,status=0,menubar=0,width=750,height=240,left=0,top=0";
		window.open(url,"p_privacyLogInqire", openParam);
	}
</script>
<title>개인정보조회 로그 목록</title>
</head>
<body>
<form name="frm" action ="<c:url value='/sym/log/plg/SelectPrivacyLogList.do'/>" method="post">
<input type="hidden" name="cal_url" value="<c:url value='/sym/cal/EgovNormalCalPopup.do'/>" />

 <table width="700" cellpadding="8" class="table-search" border="0">
	 <tr>
	  <td class="title_left">
	   <img src="<c:url value='/images/egovframework/com/cmm/icon/tit_icon.gif' />" width="16" height="16" hspace="3" align="middle" alt="제목아이콘이미지">&nbsp;개인정보조회 로그조회</td>
	  <th>
	   발생일자
	  </th>
	  <td>
	      <input name="searchBeginDate" type="hidden"  value="<c:out value='${searchVO.searchBeginDate}'/>">
	      <input name="searchBeginDateView" type="text" size="10" value="${searchVO.searchBeginDateView}"  readOnly
	      	onClick="javascript:fn_egov_NormalCalendar(document.frm, document.frm.searchBeginDate, document.frm.searchBeginDateView);" title="시작일자입력">
	      <a href="javascript:fn_egov_NormalCalendar(document.frm, document.frm.searchBeginDate, document.frm.searchBeginDateView);"
	    	style="selector-dummy:expression(this.hideFocus=false);"><img src="<c:url value='/images/egovframework/com/cmm/icon/bu_icon_carlendar.gif' />" alt="달력창팝업버튼이미지"
		    width="15" height="15"></a>
	      ~
	      <input name="searchEndDate" type="hidden"  value="<c:out value='${searchVO.searchEndDate}'/>">
	      <input name="searchEndDateView" type="text" size="10" value="${searchVO.searchEndDateView}"  readOnly
	      	onClick="javascript:fn_egov_NormalCalendar(document.frm, document.frm.searchEndDate, document.frm.searchEndDateView);" title="종료일자입력">
	      <a href="javascript:fn_egov_NormalCalendar(document.frm, document.frm.searchEndDate, document.frm.searchEndDateView);"
	    	style="selector-dummy:expression(this.hideFocus=false);"><img src="<c:url value='/images/egovframework/com/cmm/icon/bu_icon_carlendar.gif' />" alt="달력창팝업버튼이미지"
		    width="15" height="15"></a>
		</td>
		<td>조회정보</td>
	  <td>
	    <input name="searchWord" type="text" size="15" value="<c:out value='${searchVO.searchWord}'/>"  maxlength="15" title="검색단어입력">
	  </td>
	  <th>
	   <table border="0" cellspacing="0" cellpadding="0">
	    <tr>
	      <td><span class="button"><input type="submit" value="조회" onclick="javascript:fn_egov_select_privacyLog('1');return false;"></span></td>
	    </tr>
	   </table>
	  </th>
	 </tr>
	</table>
	<table width="700" cellpadding="8" class="table-line">
	 <thead>
	  <tr>
	    <!-- th class="title" width="3%" nowrap><input type="checkbox" name="all_check" class="check2"></th-->
	    <th class="title" width="5%" nowrap>번호</th>
	    <!-- th class="title" width="10%" nowrap>요청ID</th-->
	    <th class="title" width="10%" nowrap>발생일자</th>
	    <th class="title" width="25%" nowrap>서비스명</th>
	    <th class="title" width="30%" nowrap>조회정보</th>
	    <th class="title" width="10%" nowrap>요청자</th>
	    <th class="title" width="15%" nowrap>요청자IP</th>
	    <th class="title" width="5%" nowrap>상세보기</th>
	  </tr>
	 </thead>
	 <%-- 데이터를 없을때 화면에 메세지를 출력해준다 --%>
	<c:if test="${fn:length(resultList) == 0}">
	<tr>
	<td class="lt_text3" colspan="9">
		<spring:message code="common.nodata.msg" />
	</td>
	</tr>
	</c:if>
	 <tbody>
	 <c:forEach var="result" items="${resultList}" varStatus="status">
	  <tr>
	    <!--td class="lt_text3" nowrap><input type="checkbox" name="check1" class="check2"></td-->
	    <td class="lt_text3" nowrap><c:out value="${(searchVO.pageIndex-1) * searchVO.pageSize + status.count}"/></td>
	    <!-- td class="lt_text3" nowrap><c:out value="${result.requestId}"/></td-->
	    <td class="lt_text3" nowrap><c:out value="${result.inquiryDatetime}"/></td>
	    <td class="lt_text3" nowrap><c:out value="${result.serviceName}"/></td>
	    <td class="lt_text3" nowrap><c:out value="${result.inquiryInfo}"/></td>
	    <td class="lt_text3" nowrap><c:out value="${result.requesterName}"/></td>
	    <td class="lt_text3" nowrap><c:out value="${result.requesterIp}"/></td>
	    <td class="lt_text3" nowrap>
	    <a href="javascript:fn_egov_inqire_privacyLog('<c:out value="${result.requestId}"/>');"
	    	style="selector-dummy:expression(this.hideFocus=false);">
	    	<img src="<c:url value='/images/egovframework/com/cmm/icon/search.gif'/>"  alt="상세보기"
	    	width="15" height="15" align="middle"></a>
	    </td>
	  </tr>
	 </c:forEach>


	 </tbody>
	 <!--tfoot>
	  <tr class="">
	   <td colspan=6 align="center"></td>
	  </tr>
	 </tfoot -->
	</table>
<table width="700" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td height="10"></td>
  </tr>
  <tr><td>
	<div align="center">
		<ui:pagination paginationInfo = "${paginationInfo}" type="image" jsFunction="fn_egov_select_privacyLog"	/>
	</div>
  </td></tr>
</table>
	<input name="pageIndex" type="hidden" value="<c:out value='${searchVO.pageIndex}'/>"/>
</form>
</body>
</html>
