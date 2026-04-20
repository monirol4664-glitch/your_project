import React, { useState } from 'react';
import Navigation from './components/Navigation';
import Solver from './components/Solver';
import Plotter from './components/Plotter';
import TableGenerator from './components/TableGenerator';
import './styles/App.css';

function App() {
  const [activeTab, setActiveTab] = useState('solver');

  return (
    <div className="app">
      <header className="app-header">
        <h1>
          <span className="icon">📐</span>
          MathMaster Pro
        </h1>
        <p>Advanced Mathematics Toolkit</p>
      </header>
      
      <Navigation activeTab={activeTab} setActiveTab={setActiveTab} />
      
      <main className="app-main">
        {activeTab === 'solver' && <Solver />}
        {activeTab === 'plotter' && <Plotter />}
        {activeTab === 'table' && <TableGenerator />}
      </main>
      
      <footer className="app-footer">
        <p>© 2024 MathMaster Pro | Works Offline</p>
      </footer>
    </div>
  );
}

export default App;