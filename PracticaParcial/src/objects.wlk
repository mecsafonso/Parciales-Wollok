// Archivos y carpetas

class Carpeta{
	
	const property nombre
	const property listaArchivos = new Set()
	
	
	// Averiguar si una carpeta contiene un archivo con un nombre dado.
	method contiene(archivo) = listaArchivos.contains(archivo)
	
	method aplicar(commit) = commit.efecto(self)
	
	method agregarArchivoNombrado(nombreArchivo) {listaArchivos.add(new Archivo(nombre = nombreArchivo, contenido = null))}
	
	method contieneArchivoNombrado(nombreArchivo) = listaArchivos.any({archivo => archivo.nombre() == nombreArchivo})
	
	method eliminarArchivo(nombreArchivo) {listaArchivos.remove(nombreArchivo)}
	
	method aniadirTextoA(archivo,texto) = archivo.aniadirTexto(texto)
	method eliminarTextoA(archivo,texto) = archivo.eliminarTexto(texto)
	
	method checkout(branch) = branch.aplicarCambios(self)
}

class Archivo{
	
	const property nombre
	var contenido = ""
	
	method aniadirTexto(texto) {contenido = contenido + texto}
	method eliminarTexto(texto) { contenido = contenido - texto} // checkear, no funciona
	
	method log(branch) = branch.commitsQueAfectan(self)
	
}


// Commits 
class Commit{
	
	var property carpetaAModificar
	var property autor = pedro
	const property descripcion = ""
	const property cambios = new List()
	
	method agregarCambio(cambio) {cambios.add(cambio)}
	
	method aplicarCambios() { cambios.map({cambio => cambio.efecto(carpetaAModificar)})}
	
	method afectaA(archivo) = cambios.any({cambio => cambio.afectaA(archivo)})
	
	method revert() = new Commit(carpetaAModificar = self.carpetaAModificar(),descripcion = "revert " + descripcion, cambios = self.cambiosOpuestosA(cambios))
	
	method cambiosOpuestosA(listaDeCambios) = listaDeCambios.map({cambio => cambio.opuesto()})

	method agregarAutor(nombre) {self.autor(nombre)}
}

const pedro = new Autor(tipoUsuario = bot,nombre = "el pepe")

class Cambio{
	
	const property archivoObjetivo
	
	method efecto(carpeta) { 
		if(carpeta.contieneArchivoNombrado(archivoObjetivo.nombre())){}
		// 	Salvo “Crear”, los demás cambios no pueden realizarse en caso que no exista en la carpeta ningún archivo cuyo nombre sea el indicado.
		//  Cuando un cambio no pueda realizarse, debe interrumpirse la ejecución y advertir apropiadamente. 
		else self.error("No se puede realizar este cambio, no existe el archivo objetivo")
	}
	
	method afectaA(archivo) = archivoObjetivo == archivo
	
	method opuesto()
}

// “Crear”: hace que aparezca el archivo con el nombre indicado y vacío de contenido. Si ya existe un archivo con ese nombre en la carpeta, no se puede realizar este cambio.
class Crear inherits Cambio{
	
	const property nombreDeArchivoACrear
	
	override method efecto(carpeta) {
		if(!carpeta.contieneArchivoNombrado(nombreDeArchivoACrear)){
			carpeta.agregarArchivoNombrado(nombreDeArchivoACrear)
		}
		else self.error("No se puede realizar este cambio ya que existe un archivo con ese nombre")
	}
	
	override method opuesto() = new Eliminar(archivoObjetivo = self.archivoObjetivo())
	
}

// “Eliminar”: hace que desaparezca el archivo de la carpeta. 
class Eliminar inherits Cambio{
	
	override method efecto(carpeta) {
		super(carpeta)
		carpeta.eliminarArchivo(archivoObjetivo)
	}
	
	override method opuesto() = new Crear(archivoObjetivo = self.archivoObjetivo(), nombreDeArchivoACrear = self.archivoObjetivo().nombre())
	
}

// “Agregar”: implica agregar el texto indicado al final del contenido del archivo.
class Agregar inherits Cambio{
	
	const property textoAAgregar
	
	override method efecto(carpeta) {
		super(carpeta)
		carpeta.aniadirTextoA(archivoObjetivo,textoAAgregar)
	}
	
	override method opuesto() = new Sacar(archivoObjetivo = self.archivoObjetivo(), textoAEliminar = textoAAgregar)
	
}

//“Sacar”: implica sacar el texto indicado del final del contenido del archivo.
class Sacar inherits Cambio{
	
	const property textoAEliminar
	
	override method efecto(carpeta) {
		super(carpeta)
		carpeta.quitarTextoA(archivoObjetivo,textoAEliminar)
	}
	
	override method opuesto() = new Agregar(archivoObjetivo = self.archivoObjetivo(), textoAAgregar = textoAEliminar )
}


// Branches

class Branch{
	
	const property listaColaboradores = new List()
	const property conjuntoCommits = new List()
	
	method aplicarCambios() { conjuntoCommits.map({commit => commit.aplicarCambios()})}
	
	method commitsQueAfectan(archivo) = conjuntoCommits.filter({commit => commit.afectaA(archivo)})

	method agregarCommit(nuevoCommit) = {conjuntoCommits.add(nuevoCommit)}
	
	method cantidadDeCommits() = conjuntoCommits.size()
	
	method tienePermiso(autor) = listaColaboradores.contains(autor)
	
	method blame(archivo) =  archivo.log(self).map({commit => commit.autor()})

	method modificoArchivo(archivo,usuario) = conjuntoCommits.any({commit => commit.autor() == usuario })

}


// Autores

class Autor{
	
	var property tipoUsuario
	
	const property nombre
	
	method crearUnBranch(colaboradores,commits) = new Branch(listaColaboradores = colaboradores.add(self), conjuntoCommits = commits)

	method commitearEn(commit,branch) {
		if (self.tienePermisosNecesariosEn(branch)){
			commit.agregarAutor(self)
			branch.agregarCommit(commit)
		}
		else self.error("No se puede commitear")
	}	
	
	method tienePermisosNecesariosEn(branch) = tipoUsuario.permisosEn(branch,self)
	
	
	method cambiarRolUsuarios(usuarios,nuevoRol){
		if(self.puedeCambiarRoles()){
			tipoUsuario.cambiarRolUsuarios(usuarios,nuevoRol)
		}
		else self.error("Solo los administradores pueden cambiar roles")
	}
	
	method cambiarRol(nuevoRol) { self.tipoUsuario(nuevoRol)}
	
	method puedeCambiarRoles() = tipoUsuario.puedeCambiarRol()
}


object administrador{
	
	method puedeCambiarRol() = true
	
	method permisosEn(branch,autor) = true
	
	method cambiarRolUsuarios(usuarios,nuevoRol) {usuarios.forEach({usuario => self.cambiarRolA(usuario,nuevoRol)})}
	
	method cambiarRolA(usuario,nuevoRol) {usuario.cambiarRol(nuevoRol)}
}

object bot{
	
	method puedeCambiarRol() = false
	
	method permisosEn(branch,autor) = branch.cantidadDeCommits() > 10
}

object comun{
	
	method puedeCambiarRol() = false
	
	method permisosEn(branch,autor) = branch.tienePermiso(autor)
}




