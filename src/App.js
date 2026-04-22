import React, { useState } from 'react';

function App() {
  const [equation, setEquation] = useState('2x + 3 = 7');
  const [solution, setSolution] = useState(null);
  const [steps, setSteps] = useState(null);
  const [error, setError] = useState(null);

  const solveEquation = () => {
    setError(null);
    setSolution(null);
    setSteps(null);
    
    try {
      let eq = equation.replace(/\s/g, '');
      let sides = eq.split('=');
      
      if (sides.length !== 2) {
        setError('Invalid equation format. Use: expression = expression');
        return;
      }
      
      let left = sides[0];
      let right = sides[1];
      
      // Parse function
      function parseExpression(expr) {
        let xCoeff = 0;
        let constant = 0;
        
        // Handle fractions and parentheses
        let terms = expr.split(/(?=[+-])/);
        
        for (let term of terms) {
          if (term === '') continue;
          
          if (term.includes('x')) {
            let coeff = term.replace('x', '');
            if (coeff === '+' || coeff === '') coeff = '1';
            if (coeff === '-') coeff = '-1';
            
            // Handle fractions in coefficient
            if (coeff.includes('/')) {
              let fraction = coeff.split('/');
              coeff = eval(fraction[0]) / eval(fraction[1]);
            } else {
              coeff = eval(coeff);
            }
            xCoeff += coeff;
          } else {
            // Handle fractions in constant
            let val = term;
            if (val.includes('/')) {
              let fraction = val.split('/');
              val = eval(fraction[0]) / eval(fraction[1]);
            } else {
              val = eval(val);
            }
            constant += val;
          }
        }
        
        return { xCoeff, constant };
      }
      
      let leftExpr = parseExpression(left);
      let rightExpr = parseExpression(right);
      
      // Move all terms to left: left - right = 0
      let a = leftExpr.xCoeff - rightExpr.xCoeff;
      let b = leftExpr.constant - rightExpr.constant;
      
      // Solve ax + b = 0
      if (Math.abs(a) < 0.000001) {
        if (Math.abs(b) < 0.000001) {
          setError('Infinite solutions (equation is identity)');
        } else {
          setError('No solution (contradiction)');
        }
        return;
      }
      
      let x = -b / a;
      
      // Format as fraction
      let fraction = toFraction(x);
      
      setSolution(x);
      setSteps({
        a: a,
        b: b,
        fraction: fraction,
        originalLeft: left,
        originalRight: right
      });
      
    } catch(e) {
      setError('Invalid equation: ' + e.message);
    }
  };
  
  function toFraction(decimal) {
    if (Math.abs(decimal - Math.round(decimal)) < 0.000001) {
      return Math.round(decimal).toString();
    }
    
    let bestNum = 1;
    let bestDen = 1;
    let bestError = Math.abs(decimal - 1);
    
    for (let den = 1; den <= 100; den++) {
      let num = Math.round(decimal * den);
      let error = Math.abs(decimal - num/den);
      if (error < bestError) {
        bestError = error;
        bestNum = num;
        bestDen = den;
      }
      if (bestError < 0.000001) break;
    }
    
    if (bestDen === 1) return bestNum.toString();
    return `${bestNum}/${bestDen}`;
  }

  const examples = [
    { label: '2x + 3 = 7', eq: '2x + 3 = 7' },
    { label: 'x/2 + 1/3 = 3x/4', eq: 'x/2 + 1/3 = 3x/4' },
    { label: '5x - 2 = 3x + 8', eq: '5x - 2 = 3x + 8' },
    { label: 'x/3 + 2 = 5', eq: 'x/3 + 2 = 5' }
  ];

  return (
    <div style={styles.container}>
      <div style={styles.header}>
        <h1 style={styles.title}>📐 Math Solver Pro</h1>
        <p style={styles.subtitle}>Linear Equation Solver with Fractions</p>
      </div>
      
      <div style={styles.card}>
        <div style={styles.exampleButtons}>
          {examples.map((ex, i) => (
            <button 
              key={i}
              onClick={() => setEquation(ex.eq)}
              style={styles.exampleBtn}
            >
              {ex.label}
            </button>
          ))}
        </div>
        
        <div style={styles.inputGroup}>
          <label style={styles.label}>Equation:</label>
          <input 
            value={equation} 
            onChange={(e) => setEquation(e.target.value)}
            style={styles.input}
            placeholder="e.g., 2x/3 + 1/2 = 5x/6 - 1/3"
          />
        </div>
        
        <button 
          onClick={solveEquation} 
          style={styles.solveBtn}
        >
          🔍 Solve Equation
        </button>
        
        {error && (
          <div style={styles.errorBox}>
            <span style={styles.errorIcon}>⚠️</span>
            <span>{error}</span>
          </div>
        )}
        
        {solution !== null && (
          <div style={styles.solutionBox}>
            <div style={styles.solutionHeader}>
              <span>✅ Solution Found</span>
            </div>
            <div style={styles.solutionValue}>
              x = {solution.toFixed(6)}
            </div>
            <div style={styles.solutionFraction}>
              As fraction: {steps?.fraction}
            </div>
            <div style={styles.stepsBox}>
              <strong>Step-by-step:</strong>
              <div style={styles.stepText}>
                {steps?.originalLeft} = {steps?.originalRight}<br/>
                {steps?.a.toFixed(4)}x + {steps?.b.toFixed(4)} = 0<br/>
                x = -({steps?.b.toFixed(4)}) / {steps?.a.toFixed(4)}<br/>
                <strong>x = {solution.toFixed(6)}</strong>
              </div>
            </div>
          </div>
        )}
      </div>
      
      <div style={styles.footer}>
        <p>Supports: fractions (x/2), decimals (0.5x), negatives (-2x)</p>
      </div>
    </div>
  );
}

const styles = {
  container: {
    minHeight: '100vh',
    background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
    padding: '20px',
    fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif'
  },
  header: {
    textAlign: 'center',
    color: 'white',
    marginBottom: '30px'
  },
  title: {
    fontSize: '32px',
    marginBottom: '8px'
  },
  subtitle: {
    fontSize: '14px',
    opacity: 0.9
  },
  card: {
    maxWidth: '500px',
    margin: '0 auto',
    background: 'white',
    borderRadius: '20px',
    padding: '24px',
    boxShadow: '0 20px 60px rgba(0,0,0,0.3)'
  },
  exampleButtons: {
    display: 'flex',
    gap: '8px',
    flexWrap: 'wrap',
    marginBottom: '24px'
  },
  exampleBtn: {
    padding: '8px 16px',
    background: '#F3F4F6',
    border: 'none',
    borderRadius: '20px',
    fontSize: '12px',
    cursor: 'pointer',
    transition: 'all 0.2s'
  },
  inputGroup: {
    marginBottom: '20px'
  },
  label: {
    display: 'block',
    marginBottom: '8px',
    fontWeight: '600',
    color: '#374151'
  },
  input: {
    width: '100%',
    padding: '12px',
    border: '2px solid #E5E7EB',
    borderRadius: '12px',
    fontSize: '16px',
    fontFamily: 'monospace'
  },
  solveBtn: {
    width: '100%',
    padding: '14px',
    background: 'linear-gradient(135deg, #4F46E5 0%, #7C3AED 100%)',
    color: 'white',
    border: 'none',
    borderRadius: '12px',
    fontSize: '16px',
    fontWeight: '600',
    cursor: 'pointer'
  },
  errorBox: {
    marginTop: '20px',
    padding: '16px',
    background: '#FEE2E2',
    color: '#DC2626',
    borderRadius: '12px',
    display: 'flex',
    alignItems: 'center',
    gap: '8px'
  },
  errorIcon: {
    fontSize: '20px'
  },
  solutionBox: {
    marginTop: '20px',
    padding: '20px',
    background: '#F0FDF4',
    borderRadius: '12px'
  },
  solutionHeader: {
    fontSize: '14px',
    color: '#059669',
    marginBottom: '12px'
  },
  solutionValue: {
    fontSize: '32px',
    fontWeight: 'bold',
    color: '#1F2937',
    fontFamily: 'monospace',
    marginBottom: '8px'
  },
  solutionFraction: {
    fontSize: '14px',
    color: '#6B7280',
    marginBottom: '16px'
  },
  stepsBox: {
    background: 'white',
    padding: '16px',
    borderRadius: '8px',
    fontSize: '13px'
  },
  stepText: {
    marginTop: '8px',
    lineHeight: '1.6',
    color: '#4B5563'
  },
  footer: {
    textAlign: 'center',
    marginTop: '24px',
    color: 'white',
    fontSize: '12px',
    opacity: 0.8
  }
};

export default App;