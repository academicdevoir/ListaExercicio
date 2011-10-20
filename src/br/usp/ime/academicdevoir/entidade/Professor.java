package br.usp.ime.academicdevoir.entidade;

import java.util.ArrayList;
import java.util.Collection;

import javax.persistence.Entity;
import javax.persistence.OneToMany;

@Entity
public class Professor extends Usuario {
	/**
	 * @uml.property  name="turmas"
	 * @uml.associationEnd  multiplicity="(0 -1)" inverse="professor:br.usp.ime.academicdevoir.entidade.Turma"
	 */
	@OneToMany(mappedBy = "professor")
	private Collection<Turma> turmas = new ArrayList<Turma>();


	public Collection<Turma> getTurmas() {
		return turmas;
	}

	public void setTurmas(Collection<Turma> turmas) {
		this.turmas = turmas;
	}
}