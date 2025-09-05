
// Clase Empresa (hoy se ingresaria para test)

class Empresa(cuit, nombre) {

  var empleados = []

  method agregarEmpleado(e) { empleados.add(e) }

  method totalSueldoBrutos(hoy) = empleados.map({ e => e.sueldoBruto(hoy) }).sum()

  method totalSueldoNetos(hoy) = empleados.map({ e => e.sueldoNeto(hoy) }).sum()

  method totalRetenciones(hoy) = empleados.map({ e => e.retenciones(hoy) }).sum()

  method liquidarSueldos(hoy) {
    return empleados.map({ e =>
      new Recibo(
        e.nombre,
        e.direccion,
        hoy,
        e.sueldoBruto(hoy),
        e.sueldoNeto(hoy),
        e.conceptos(hoy)
      )
    })
  }
}


// Clase abstracta Empleado

abstract class Empleado(nombre, direccion, estadoCivil, fechaNac, sueldoBasico) {

  method edadAl(hoy) {
    var edad = hoy.anio - fechaNac.anio
    if (hoy.mes < fechaNac.mes || (hoy.mes == fechaNac.mes && hoy.dia < fechaNac.dia)) {
      edad = edad - 1
    }
    return edad
  }

  method sueldoNeto(hoy) = this.sueldoBruto(hoy) - this.retenciones(hoy)

  abstract method sueldoBruto(hoy)
  abstract method retenciones(hoy)
  abstract method conceptos(hoy)
}



// Empleado Permanente

class Permanente(nombre, direccion, estadoCivil, fechaNac, sueldoBasico, hijos, antiguedad) 
  inherits Empleado(nombre, direccion, estadoCivil, fechaNac, sueldoBasico) {

  method asignacionPorHijo() = hijos * 150

  method asignacionPorConyuge() {
    var monto = 0
    if (estadoCivil.toLowerCase() == "casado") {
      monto = 100
    }
    return monto
  }

  method plusAntiguedad() = antiguedad * 50

  method sueldoBruto(hoy) = sueldoBasico + asignacionPorHijo() + asignacionPorConyuge() + plusAntiguedad()

  method obraSocial(hoy) = (this.sueldoBruto(hoy) * 0.10) + (20 * hijos)

  method jubilacion(hoy) = this.sueldoBruto(hoy) * 0.15

  method retenciones(hoy) = this.obraSocial(hoy) + this.jubilacion(hoy)

  method conceptos(hoy) {
    var lista = []
    lista.add(new Concepto("Sueldo Básico", sueldoBasico, "bruto"))
    if (hijos > 0) { lista.add(new Concepto("Asignación por hijo", asignacionPorHijo(), "bruto")) }
    if (this.asignacionPorConyuge() > 0) { lista.add(new Concepto("Asignación por cónyuge", 100, "bruto")) }
    if (antiguedad > 0) { lista.add(new Concepto("Antigüedad", plusAntiguedad(), "bruto")) }
    lista.add(new Concepto("Obra Social", this.obraSocial(hoy), "retencion"))
    lista.add(new Concepto("Jubilación", this.jubilacion(hoy), "retencion"))
    return lista
  }
}



// Empleado Temporal

class Temporal(nombre, direccion, estadoCivil, fechaNac, sueldoBasico, fechaFin, horasExtras) 
  inherits Empleado(nombre, direccion, estadoCivil, fechaNac, sueldoBasico) {

  method valorHorasExtras() = horasExtras * 40

  method sueldoBruto(hoy) = sueldoBasico + valorHorasExtras()

  method obraSocial(hoy) {
    var plusEdad = 0
    if (this.edadAl(hoy) > 50) {
      plusEdad = 25
    }
    return (this.sueldoBruto(hoy) * 0.10) + plusEdad
  }

  method jubilacion(hoy) = (this.sueldoBruto(hoy) * 0.10) + (5 * horasExtras)

  method retenciones(hoy) = this.obraSocial(hoy) + this.jubilacion(hoy)

  method conceptos(hoy) {
    var lista = []
    lista.add(new Concepto("Sueldo Básico", sueldoBasico, "bruto"))
    if (horasExtras > 0) { lista.add(new Concepto("Horas Extras", valorHorasExtras(), "bruto")) }
    lista.add(new Concepto("Obra Social", this.obraSocial(hoy), "retencion"))
    lista.add(new Concepto("Jubilación", this.jubilacion(hoy), "retencion"))
    return lista
  }
}



// Clase Recibo

class Recibo(nombreEmpleado, direccion, fechaEmision, sueldoBruto, sueldoNeto, conceptos) {
  method imprimir() {
    println("=====================================")
    println("RECIBO DE HABERES")
    println("Empleado: " + nombreEmpleado)
    println("Dirección: " + direccion)
    println("Fecha: " + fechaEmision.dia + "/" + fechaEmision.mes + "/" + fechaEmision.anio)
    println("-------------------------------------")
    conceptos.forEach({ c => println(c.tipo + " - " + c.descripcion + ": $" + c.monto) })
    println("-------------------------------------")
    println("Sueldo Bruto: $" + sueldoBruto)
    println("Sueldo Neto : $" + sueldoNeto)
    println("=====================================")
  }
}



// Clase Concepto

class Concepto(descripcion, monto, tipo) {
  method esBruto() = tipo == "bruto"
  method esRetencion() = tipo == "retencion"
}



// Clase Fecha (utilidad)
class Fecha(anio, mes, dia) { }