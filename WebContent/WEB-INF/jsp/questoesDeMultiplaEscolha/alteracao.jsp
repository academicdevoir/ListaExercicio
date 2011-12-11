<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" language="java"
import="java.sql.*" errorPage="" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<link rel="stylesheet" type="text/css" charset="utf-8" media="screen" href="<c:url value="/css/jquery.ui.core.css"/>"/>
<link rel="stylesheet" type="text/css" charset="utf-8" media="screen" href="<c:url value="/css/jquery.ui.theme.css"/>"/>
<link rel="stylesheet" type="text/css" charset="utf-8" media="screen" href="<c:url value="/css/jquery.ui.autocomplete.css"/>"/>
<script type="text/javascript" charset="utf-8" src="<c:url value="/javascript/jquery-1.7.1.min.js"/>"></script>
<script type="text/javascript" charset="utf-8" src="<c:url value="/javascript/jquery-ui/jquery.ui.core.min.js"/>"></script>
<script type="text/javascript" charset="utf-8" src="<c:url value="/javascript/jquery-ui/jquery.ui.position.min.js"/>"></script>
<script type="text/javascript" charset="utf-8" src="<c:url value="/javascript/jquery-ui/jquery.ui.widget.min.js"/>"></script>
<script type="text/javascript" charset="utf-8" src="<c:url value="/javascript/jquery-ui/jquery.ui.autocomplete.min.js"/>"></script>
<script type="text/javascript" charset="utf-8">
	function liberaAlternativas(respostaUnica, numeroDeAlternativas) {
		var i = 0;
		var tipo, outro;
		
		if (respostaUnica == 'checked') {
			tipo = 'Unica';
			outro = 'Multipla';
		}
		
		else {
			tipo = 'Multipla';
			outro = 'Unica';
		}
		
		while (i < numeroDeAlternativas) {
			$('#resposta' + tipo + i).removeAttr('disabled').show();
			$('#alternativa'+i).removeAttr('disabled').show();
			$('#espacoAlternativas'+i).show();
			$('#espacoAlternativas2_'+i).show();
			$('#resposta' + outro + i).attr('disabled', 'disabled').hide();
			i++;
		}
		
		while (i < 10) {
			$('#resposta' + tipo + i).attr('disabled', 'disabled').hide();
			$('#alternativa'+i).attr('disabled', 'disabled').hide();
			$('#espacoAlternativas'+i).hide();
			$('#espacoAlternativas2_'+i).hide();
			$('#resposta' + outro + i).attr('disabled', 'disabled').hide();
			i++;
		}
	}

 	function split( val ) {
		return val.split( /,\s*/ );
	}
	
	function extractLast( term ) {
		return split( term ).pop();
	}
	
	$(document).ready(function(){
		var numeroDeAlternativas = ${numeroDeAlternativas};
		liberaAlternativas($('#tipoDeResposta').attr('checked'), numeroDeAlternativas);
		
		$('#seletorDeAlternativas').change(function() {
	 		var valor = $(this).val();	 		
	 		numeroDeAlternativas = parseInt(valor);
	 		liberaAlternativas($('#tipoDeResposta').attr('checked'), numeroDeAlternativas);
		});

	 	$('#tipoDeResposta').change(function() {
	 		liberaAlternativas($(this).attr('checked'), numeroDeAlternativas);
	 	});
	 	
	 	//Adaptado do exemplo do JQuery UI 
	 	$('#tags')
		.bind('keydown', function(event) {
			if (event.keyCode === $.ui.keyCode.TAB &&
					$(this).data('autocomplete').menu.active) {
				event.preventDefault();
			}
		})
		.autocomplete({
			source: function(request, response) {
				$.getJSON('<c:url value="/questoes/tags/autocompletar.json"/>', {
					term: extractLast(request.term)
				}, 
				function(result) {
					response($.map(result, function(item) {
						return item.nome;
					}));
				});
			},
			search: function() {
				var term = extractLast(this.value);
				if (term.length < 2) {
					return false;
				}
			},
			focus: function() {
				return false;
			},
			select: function(event, ui) {
				var terms = split(this.value);
				terms.pop();
				terms.push(ui.item.value);
				terms.push("");
				this.value = terms.join(", ");
				return false;
			}
		});
	});
</script>
<style type="text/css">
body
{
background-color:#f0ecc6;
}
h1 
{
color: black;
text-align: center;
font-size: 40px;
font-family:"Times New Roman";
font-style: italic;
font-variant: small-caps;
}
h2
{
color: black;
text-align: center;
font-size: 20px;
font-family:"Times New Roman";
}

legend 
{
color: #8c550e;
}
form {
margin: 3em auto;
width: 62%;
}
p{
display: inline;
}
.fieldsetSemFormatacao{
	border:none;
	padding: 0px;
}
</style>
</head>

<body>
	<h1>Academic Devoir</h1>
	<h2>Grupo 1 - Engenharia de Software</h2>
	<div>
		<%@ include file="../questoes/menu.jsp" %>
	</div>
	
	<div>
		<br/>	
		
		<form action="<c:url value="/questoes/mult/${questao.id }"/>" method="post" accept-charset="utf-8">
			<fieldset>
				<legend>Alterar questão de múltipla escolha</legend>
				<br/>
				<label for="enunciado">Enunciado:</label><br/>
					<textarea id="enunciado" rows= "5" cols="80" name="questao.enunciado">${questao.enunciado }</textarea>
				<br/>
				<label for="tags">Tags: </label>
					<input id="tags" type="text" name="tags" value="${tags }"></input>
				<br/> 
				<p>Número de Alternativas: </p>
					<select id="seletorDeAlternativas" name="numeroDeAlternativas">
						<c:forEach begin="2" end="10" step="1" varStatus="iteracao">
							<c:choose>
								<c:when test="${iteracao.index eq numeroDeAlternativas }">
									<option selected="selected" value="${iteracao.index }">${iteracao.index }</option>
								</c:when>
								<c:otherwise>
									<option value="${iteracao.index }">${iteracao.index }</option>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</select>					
					<br/>
					<p>Resposta única: </p>
					<input id="tipoDeResposta" type="checkbox" checked="checked" name="questao.respostaUnica" value="true" />
					<br/><br/>
					<label>Alternativas:</label>
					<c:set var="valorResposta" value="1" />
					<c:set var="verdadeiro" value="${questao.resposta }" />
					<c:forEach items="${questao.alternativas }" var="alternativa" varStatus="iteracao">
						<br id="espacoAlternativas${iteracao.index }"/>
						<br id="espacoAlternativas2_${iteracao.index }"/>
						<c:choose>
							<c:when test="${verdadeiro % 2 eq 1 }">
								<c:choose>
									<c:when test="${respostaUnica }">
										<input id="respostaUnica${iteracao.index }" class="respostaDasAlternativas" type="radio" checked="checked" name="resposta[]" value="${valorResposta }" />
										<input id="respostaMultipla${iteracao.index }" class="respostaDasAlternativas" type="checkbox" checked="checked" name="resposta[]" value="${valorResposta }" disabled="disabled" />
									</c:when>
									<c:otherwise>
										<input id="respostaUnica${iteracao.index }" class="respostaDasAlternativas" type="radio" checked="checked" name="resposta[]" value="${valorResposta }" disabled="disabled" />
										<input id="respostaMultipla${iteracao.index }" class="respostaDasAlternativas" type="checkbox" checked="checked" name="resposta[]" value="${valorResposta }"/>
									</c:otherwise>
								</c:choose>
							</c:when>
							<c:otherwise>
								<c:choose>
									<c:when test="${respostaUnica }">
										<input id="respostaUnica${iteracao.index }" class="respostaDasAlternativas" type="radio" name="resposta[]" value="${valorResposta }" />
										<input id="respostaMultipla${iteracao.index }" class="respostaDasAlternativas" type="checkbox" name="resposta[]" value="${valorResposta }" disabled="disabled" />
									</c:when>
									<c:otherwise>
										<input id="respostaUnica${iteracao.index }" class="respostaDasAlternativas" type="radio" name="resposta[]" value="${valorResposta }" disabled="disabled" />
										<input id="respostaMultipla${iteracao.index }" class="respostaDasAlternativas" type="checkbox" name="resposta" value="${valorResposta }"/>
									</c:otherwise>
								</c:choose>
							</c:otherwise>
						</c:choose>							
							<input  id="alternativa${iteracao.index }" class="alternativa" type="text" size="100" name="questao.alternativas[${iteracao.index }]" value="${alternativa }" />
							<c:set var="valorResposta" value="${valorResposta*2 }"/>
							<c:set var="verdadeiro" value="${verdadeiro/2 }"/>														
					</c:forEach>
					
					<c:forEach begin="${numeroDeAlternativas }" end="9" step="1" varStatus="iteracao">
						<br id="espacoAlternativas${iteracao.index }"/>
						<br id="espacoAlternativas2_${iteracao.index }"/>
						
						<input id="respostaUnica${iteracao.index }" class="respostaDasAlternativas" type="radio" name="questao.resposta" value="${valorResposta }" disabled="disabled" />
						<input id="respostaMultipla${iteracao.index }" class="respostaDasAlternativas" type="checkbox" name="questao.resposta" value="${valorResposta }" disabled="disabled" />
						<input  id="alternativa${iteracao.index }" class="alternativa" type="text" size="100" name="questao.alternativas[${iteracao.index }]" disabled="disabled" />
						
						<c:set var="valorResposta" value="${valorResposta*2 }"/>
					</c:forEach>
					
				<br/>
				<button type="submit" name="_method" value="put">Salvar Alterações</button>
			</fieldset>
		</form>
		<br/>
	</div>
	   <a href="<c:url value='/login'/>">Sair</a>
       <a href="<c:url value='/professores/home'/>">Página Principal</a><br/>
</body>
</html>