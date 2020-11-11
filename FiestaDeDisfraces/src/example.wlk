class FiestaDeDisfraces{
	
	const property lugar
	const property fecha = new Date()
	const property listaInvitados = new List()
	
	method esBrodio() = listaInvitados.all({invitado => !invitado.estaConforme()})
	
	method elMejorDisfraz() = listaInvitados.max({invitado => invitado.puntajePorDisfraz()}).disfraz()

	method puedenCambiarDisfraces(persona,otraPersona) {
		
		if(self.estanEnMismaFiesta(persona,otraPersona)){
			if(self.algunoEstaDisconforme(persona,otraPersona)){
				if(self.ambosQuedanConformesAlCambiar(persona,otraPersona)){
					return true
				}else {self.error("No pueden intercambiar disfraces ya que alguno no quedaria conforme") return false}
			}else {self.error("No pueden intercambiar disfraces ya que ambos estan conformes con su traje") return false}
		}else {self.error("No pueden intercambiar disfraces ya que no estan en la misma fiesta") return false}
	}
	
	method agregarInvitado(persona) {
		if(persona.tieneDisfraz() and !listaInvitados.contains(persona)){
			listaInvitados.add(persona)
		}
		else self.error("No se puede agregar al invitado")
	}
		

	method estanEnMismaFiesta(persona,otraPersona) = listaInvitados.contains(persona) and listaInvitados.contains(otraPersona)// persona.fiesta() == otraPersona.fiesta()
	
	method algunoEstaDisconforme(persona,otraPersona) = !persona.estaConforme() or !otraPersona.estaConforme()
	
	// checkear como se menea UhuHuhUhu uhhhhhhhhhhhhhhhhh UHHHHHHHHH UHHHHHHH CHECKA COMO SE MENEA
	method ambosQuedanConformesAlCambiar(persona,otraPersona) {
		const disfrazCambiado = otraPersona.disfraz()
		otraPersona.cambiarDisfraz(persona.disfraz())
		persona.cambiarDisfraz(disfrazCambiado)
		const resultado = (persona.estaConforme() and otraPersona.estaConforme())
		persona.cambiarDisfraz(otraPersona.disfraz())
		otraPersona.cambiarDisfraz(disfrazCambiado)
		return resultado
	}
}

class FiestaInolvidable inherits FiestaDeDisfraces{
	
	override method agregarInvitado(persona){
		if(persona.esSexy() and persona.estaConforme()){
			super(persona)
		}
		else self.error("No se puede agregar al invitado")
	}
}

class Invitado{
	
	const property fiesta
	const property edad 
	var property disfraz
	var property personalidad
	
	method cambiarDisfraz(nuevoDisfraz){self.disfraz(nuevoDisfraz)}
	
	method puntajePorDisfraz() = disfraz.listaCaracteristicas().map({caracteristica => caracteristica.puntajeAportado(self.disfraz(),self)}).sum()
	
	method esSexy() = personalidad.esSexy(self.edad())
	
	method estaConforme() = self.puntajePorDisfraz() > 10 // sad life
	
	method tieneDisfraz() = disfraz != null
}


class Caprichoso inherits Invitado{
	override method estaConforme() = disfraz.nombre().length().even() and super()
}

class Pretencioso inherits Invitado{
	override method estaConforme() = disfraz.fechaConfeccionado() < disfraz.fechaConfeccionado().minusMonth(1)
}

class Numerologo inherits Invitado{
	
	const property puntajeNecesario
	
	override method estaConforme() =  self.puntajePorDisfraz() == puntajeNecesario
}


class Personalidad{
	method esSexy(edad)
}

object alegre inherits Personalidad{
	override method esSexy(edad) = false
}

object taciturnas inherits Personalidad{
	override method esSexy(edad) = edad < 30
}

object cambiante inherits Personalidad{
	
	var property personalidadActual
	
	method cambiarPersonalidad(nuevaPersonalidad) {self.personalidadActual(nuevaPersonalidad)}
	
	override method esSexy(edad) = personalidadActual.esSexy()
}






class Disfraz{
	
	const property fechaConfeccionado = new Date()
	const property nivelDeGracia
	const property nombre
	const property listaCaracteristicas = new List()
	
	

}


class Caracteristica {
	method puntajeAportado(disfraz,persona)
}

object gracioso inherits Caracteristica{
	
	override method puntajeAportado(disfraz,persona) {
		if(persona.edad() > 50){
			return disfraz.nivelDeGracia() * 3
		}
		return disfraz.nivelDeGracia()
	}
	
}

object tobaras inherits Caracteristica{
	
	override method puntajeAportado(disfraz,persona){
		if(disfraz.fechaConfeccionado() <= persona.fiesta().fecha().minusDays(2)){ 
			return 5
		}
		else return 3
	}
	
}

object caretas inherits Caracteristica{
	
	const property personajeQueSimula = mickeyMouse
	
	override method puntajeAportado(disfraz,persona) = personajeQueSimula.valor()
		
}

class Personaje{
	const property valor
}

const mickeyMouse = new Personaje(valor = 8)
const osoCarolina = new Personaje(valor = 6)


object sexies inherits Caracteristica{
	
	override method puntajeAportado(disfraz,persona){
		if (persona.esSexy()){
			return 15
		}
		return 2
		
	}
}