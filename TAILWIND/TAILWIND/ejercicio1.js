document.getElementById('miEnlace').addEventListener('click', function(event) {
    event.preventDefault(); // Evita que el enlace abra una nueva página
    alert('Enlace deshabilitado');
});

document.getElementById('formulario').addEventListener('click', function(event) {
    event.preventDefault(); // Evita que el enlace abra una nueva página
    alert('campo desabilitado');
});

document.getElementById('miBoton').addEventListener('click', function(event) {
    event.preventDefault(); // Evita el comportamiento predeterminado del botón
    // Puedes realizar otras acciones aquí
    alert('Botón clickeado, pero no se realizará su acción predeterminada');
});
