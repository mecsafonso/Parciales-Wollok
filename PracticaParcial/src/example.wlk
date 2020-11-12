class Empleado{
	
	const property misionesCompletadas = new List()
	const property habilidades = new List()
	var property tipoEmpleado
	var property salud
	
	
	method estaIncapacitado() = salud < self.saludCritica()
	method saludCritica() = tipoEmpleado.saludCritica()
	method puedeUsar(habilidad) = habilidades.contains(habilidad) && !self.estaIncapacitado()
	method recibirDanio(cantidad) {salud -= cantidad}
	method puedeCumplir(mision) = self.tieneHabilidades(mision.habilidadesRequeridas())
	method tieneHabilidades(habilidadess) = habilidades.all({habilidad => habilidades.contains(habilidad)})
	method sobrevive() = salud > 0
	
	method registrarMision(mision){
		misionesCompletadas.add(mision)
	}
}

object espia{
	
	method saludCritica() = 15
	
	method aprender(habilidad) {habilidades.add(habilidad)}
	
	override method registrarMision(mision){
		
	}
}

object oficinista{
	
	var property estrellas
	
	method saludCritica() = 40 - 5 * estrellas
	
	method ganarEstrella() {estrellas += 1}
	
	override method registrarMision(mision){
		self.ganarEstrella()
		self.intentarEvolucionar()
		
	}
}

object jefe {
	
	const property subordinados = new List()
	
	method puedeUsar(habilidad) = super(habilidad) or self.algunSubordinadoPuedeUsar(habilidad)
	
	method algunSubordinadoPuedeUsar(habilidad) = subordinados.any({subordinado => subordinado.puedeUsar(habilidad)})
}

class Mision{
	const property habilidadesRequeridas = new List()
	const property peligrosidad
	
	method causarEfectoSolitario(empleado) {
		empleado.recibirDanio(peligrosidad)
		if(empleado.sobrevive()){
			empleado.registrarMision(self)			
		}
	}
	
	method causarEfectoMultiple(equipo){
		
	}
	
}


object isis{
	
	method cumplirMisionSolitario(empleado,mision){
		if(empleado.puedeCumplir(mision)){
			mision.causarEfectoSolitario(empleado)
		}
		else self.error("No se puede cumplir la mision")
	}
	
	method cumplirMisionEnEquipo(equipo,mision){
		if(self.todosPuedenCumplir(equipo,mision)){
			mision.causarEfectoMultiple(equipo)
		}
		else self.error("No se puede cumplir la mision")
	}
	
	method todosPuedenCumplir(equipo,mision) = equipo.all({empleado => empleado.puedeCumplir(mision)})
	
}