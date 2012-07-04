package br.usp.ime.academicdevoir.controller;

import br.com.caelum.vraptor.Delete;
import br.com.caelum.vraptor.Get;
import br.com.caelum.vraptor.Path;
import br.com.caelum.vraptor.Post;
import br.com.caelum.vraptor.Put;
import br.com.caelum.vraptor.Resource;
import br.com.caelum.vraptor.Result;
import br.com.caelum.vraptor.Validator;
import br.com.caelum.vraptor.validator.Validations;
import br.usp.ime.academicdevoir.dao.DisciplinaDao;
import br.usp.ime.academicdevoir.dao.QuestaoDeTextoDao;
import br.usp.ime.academicdevoir.dao.TagDao;
import br.usp.ime.academicdevoir.entidade.Disciplina;
import br.usp.ime.academicdevoir.entidade.QuestaoDeTexto;
import br.usp.ime.academicdevoir.infra.Permission;
import br.usp.ime.academicdevoir.infra.Privilegio;
import br.usp.ime.academicdevoir.infra.UsuarioSession;

@Permission({ Privilegio.ADMINISTRADOR, Privilegio.PROFESSOR })
@Resource
/**
 * Controlador de questões de texto.
 */
public class QuestoesDeTextoController {

	/**
	 * @uml.property name="dao"
	 * @uml.associationEnd multiplicity="(1 1)"
	 */
	private QuestaoDeTextoDao dao;
	/**
	 * @uml.property name="result"
	 * @uml.associationEnd multiplicity="(1 1)"
	 */
	private final Result result;
	/**
	 * @uml.property name="validator"
	 * @uml.associationEnd multiplicity="(1 1)"
	 */
	private Validator validator;
	private TagDao tagDao;
	private DisciplinaDao disciplinaDao;

	/**
	 * @param result
	 *            para interação com o jsp da questão.
	 * @param validator
	 * @param usuarioSession
	 *            para controle de permissões
	 * @param turmaDao
	 *            para interação com o banco de dados
	 */
	public QuestoesDeTextoController(QuestaoDeTextoDao dao, TagDao tagDao, DisciplinaDao disciplinaDao,
			Result result, Validator validator, UsuarioSession usuarioSession) {
		this.dao = dao;
		this.tagDao = tagDao;
		this.disciplinaDao = disciplinaDao;
		this.result = result;
		this.validator = validator;
	}

	@Post
	@Path("/questoes/texto")
	/**
	 * Verifica se a questão de texto fornecida é válida e adiciona no banco de dados.
	 * @param questao
	 */
	public void cadastra(final QuestaoDeTexto questao, String tags) {
		
		validator.checking(new Validations() {{
			that(questao.getDisciplina().getId() != null, "questao.id", "questao.id.notNull");
		}});
		
		validator.validate(questao);
		validator.onErrorRedirectTo(QuestoesController.class).cadastro();

		questao.setTags(tags, tagDao);
		
		Disciplina disciplina = disciplinaDao.carrega(questao.getDisciplina().getId());
		disciplina.setTags(tags, tagDao);
		
		disciplinaDao.atualiza(disciplina);
		dao.salva(questao);
		result.redirectTo(this).lista();
	}

	@Get
	@Path("/questoes/texto/{id}")
	/** 
	 * Devolve uma questão de texto com o id fornecido.
	 * @param id
	 */
	public void alteracao(Long id) {

		QuestaoDeTexto questao = dao.carrega(id);
		result.include("questao", questao);
		result.include("tags", questao.getTagsEmString());
	}

	@Put
	@Path("/questoes/texto/{questao.id}")
	/**
	 * Verifica se a questão de texto fornecida é válida e atualiza no banco de dados.
	 * @param id
	 */
	public void altera(QuestaoDeTexto questao, String tags) {
		questao.setTags(tags, tagDao);

		validator.validate(questao);
		validator.onErrorUsePageOf(QuestoesDeTextoController.class).alteracao(
				questao.getId());

		dao.atualiza(questao);
		result.redirectTo(this).lista();
	}

	@Delete
	@Path("/questoes/texto/{id}")
	/**
	 * Remove uma questão de texto do banco de dados com o id fornecido.
	 * @param id
	 */
	public void remove(Long id) {
		QuestaoDeTexto questao = dao.carrega(id);
		dao.remove(questao);
		result.redirectTo(this).lista();
	}

	@Get
	@Path("/questoes/texto")
	/**
	 * Devolve uma lista com todas as questões de texto cadastradas no banco de dados.
	 */
	public void lista() {
		result.include("lista", dao.listaTudo());
	}

	public void copia(QuestaoDeTexto questao) {
		dao.salva(questao);
		result.redirectTo(this).alteracao(questao.getId());		
	}
}
