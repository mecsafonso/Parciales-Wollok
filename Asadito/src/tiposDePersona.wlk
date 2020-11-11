import example.*

object sordo{
	
	method primerElemento(persona) = persona.elementosCerca().first()
	
	method pasar(cosa,personaObjetivo,personaConCosa){
		personaObjetivo.tomar(self.primerElemento(personaConCosa))
		personaConCosa.dejarIr(self.primerElemento(personaConCosa))
	}
}

object pasadorCompulsivo{
	
	method pasar(cosa,personaObjetivo,personaConCosa){
		
		
		personaObjetivo.tomarTodos(personaConCosa.elementosCerca())
		personaConCosa.dejarIrTodos()
	}
	
}

object intercambiadorDeLugar{
	var elementosLugar1
	var elementosLugar2
	
	method pasar(cosa,personaObjetivo,personaConCosa){
		elementosLugar1 = personaObjetivo.elementosCerca()
		elementosLugar2 = personaConCosa.elementosCerca()
		personaObjetivo.irAlLugarDe(personaConCosa)
		personaConCosa.irAlLugarDe(personaObjetivo)
		personaObjetivo.reemplazarElementosPor(elementosLugar2)
		personaConCosa.reemplazarElementosPor(elementosLugar1)
	}
	
}

object personaNormal{
	
	method pasar(cosa,personaObjetivo,personaConCosa){
		personaObjetivo.tomar(cosa)
		personaConCosa.dejarIr(cosa)
	}
	
}
