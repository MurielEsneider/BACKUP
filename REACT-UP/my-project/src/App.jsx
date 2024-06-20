import { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'

//RUTAS
import { BrowserRouter, Routes, Route, Link } from 'react-router-dom';
import Contacto from './pages/publicas/Contacto';
import Nosotros from './pages/publicas/Nosotros';
import Servicios from './pages/publicas/Servicios'; 







function App() {
  return (

    <>
    <header>
      <h1>Hola</h1>
    </header>
  
    
  
    <BrowserRouter>
        <nav>
          <ul>
            <li>
              <Link to='/contacto'>Contacto</Link><br></br>
              <Link to='/servicios'>Servicios</Link><br></br>
              <Link to='/nosotros'>Nosotros</Link>
            </li>
          </ul>
        </nav>  
      


      <Routes>
        <Route path='/contacto' element={<Contacto />} />
        <Route path='/nosotros' element={<Nosotros />} />
        <Route path='/servicios' element={<Servicios />} />
      </Routes>
    </BrowserRouter>
    </>
  );
}

export default App;