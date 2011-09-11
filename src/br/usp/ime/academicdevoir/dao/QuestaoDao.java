package br.usp.ime.academicdevoir.dao;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Restrictions;

import br.usp.ime.academicdevoir.entidade.Questao;
import br.com.caelum.vraptor.ioc.Component;

@Component
public class QuestaoDao {

	private final Session session;

	public QuestaoDao(Session session) {
		this.session = session;
	}

	public List<Questao> listaTudo() {
		return this.session.createCriteria(Questao.class).list();
	}

	/**
	 * Retorna uma questão com o id fornecido.
	 * @param id
	 * @return Questao
	 */
	public Questao carrega(Long id) {
		return (Questao) this.session.load(Questao.class, id);
	}

	/**
	 * Remove a questão fornecida do banco de dados.
	 * @param questao
	 */
	public void remove(Questao questao) {
		Transaction tx = session.beginTransaction();
		this.session.delete(questao);
		tx.commit();
	}

	public List<Questao> busca(String title) {
		return session.createCriteria(Questao.class)
				.add(Restrictions.ilike("title", title, MatchMode.ANYWHERE))
				.list();
	}

	public void recarrega(Questao questao) {
		session.refresh(questao);
	}

}