// Funcionalidade AJAX para operações de trading

document.addEventListener('DOMContentLoaded', function() {
  // Configurar AJAX para formulários de trade
  const tradeForm = document.querySelector('#new_trade');
  if (tradeForm) {
    setupTradeFormAjax(tradeForm);
  }
  
  // Configurar AJAX para exclusão de trades
  setupTradeDeleteAjax();
  
  // Auto-refresh das estatísticas a cada 30 segundos
  if (document.querySelector('.stats-container')) {
    setInterval(refreshStats, 30000);
  }
});

function setupTradeFormAjax(form) {
  form.addEventListener('submit', function(e) {
    e.preventDefault();
    
    const formData = new FormData(form);
    const submitButton = form.querySelector('input[type="submit"]');
    const originalText = submitButton.value;
    
    // Mostrar loading
    submitButton.value = 'Criando...';
    submitButton.disabled = true;
    
    fetch(form.action, {
      method: 'POST',
      body: formData,
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      }
    })
    .then(response => response.json())
    .then(data => {
      if (data.status === 'success') {
        showAlert('success', data.message);
        form.reset();
        
        // Atualizar estatísticas se estiver na página de dashboard
        if (document.querySelector('.stats-container')) {
          refreshStats();
        }
        
        // Redirecionar após 2 segundos
        setTimeout(() => {
          window.location.href = '/trades';
        }, 2000);
      } else {
        showAlert('danger', 'Erro: ' + data.errors.join(', '));
      }
    })
    .catch(error => {
      console.error('Erro:', error);
      showAlert('danger', 'Erro ao processar a requisição.');
    })
    .finally(() => {
      // Restaurar botão
      submitButton.value = originalText;
      submitButton.disabled = false;
    });
  });
}

function setupTradeDeleteAjax() {
  document.addEventListener('click', function(e) {
    if (e.target.matches('a[data-method="delete"]')) {
      e.preventDefault();
      
      const link = e.target;
      const confirmMessage = link.getAttribute('data-confirm');
      
      if (confirmMessage && !confirm(confirmMessage)) {
        return;
      }
      
      fetch(link.href, {
        method: 'DELETE',
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        }
      })
      .then(response => response.json())
      .then(data => {
        if (data.status === 'success') {
          showAlert('success', data.message);
          
          // Remover a linha da tabela
          const row = link.closest('tr');
          if (row) {
            row.remove();
          }
          
          // Atualizar estatísticas
          refreshStats();
        } else {
          showAlert('danger', data.message);
        }
      })
      .catch(error => {
        console.error('Erro:', error);
        showAlert('danger', 'Erro ao excluir a operação.');
      });
    }
  });
}

function refreshStats() {
  fetch('/trades/stats', {
    headers: {
      'X-Requested-With': 'XMLHttpRequest',
      'Accept': 'application/json'
    }
  })
  .then(response => response.json())
  .then(data => {
    updateStatsDisplay(data);
  })
  .catch(error => {
    console.error('Erro ao atualizar estatísticas:', error);
  });
}

function updateStatsDisplay(stats) {
  // Atualizar contadores
  const elements = {
    'total-trades': stats.total_trades,
    'open-trades': stats.open_trades,
    'matched-trades': stats.matched_trades,
    'total-pairs': stats.total_pairs,
    'total-profit': '$' + parseFloat(stats.total_profit || 0).toFixed(2)
  };
  
  Object.keys(elements).forEach(id => {
    const element = document.getElementById(id);
    if (element) {
      element.textContent = elements[id];
    }
  });
  
  // Atualizar cor do lucro
  const profitElement = document.getElementById('total-profit');
  if (profitElement) {
    const profit = parseFloat(stats.total_profit || 0);
    profitElement.className = profit >= 0 ? 'text-success' : 'text-danger';
  }
}

function showAlert(type, message) {
  // Remover alertas existentes
  const existingAlerts = document.querySelectorAll('.alert-ajax');
  existingAlerts.forEach(alert => alert.remove());
  
  // Criar novo alerta
  const alertDiv = document.createElement('div');
  alertDiv.className = `alert alert-${type} alert-dismissible fade show alert-ajax`;
  alertDiv.innerHTML = `
    ${message}
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  `;
  
  // Inserir no topo da página
  const container = document.querySelector('.container') || document.body;
  container.insertBefore(alertDiv, container.firstChild);
  
  // Auto-remover após 5 segundos
  setTimeout(() => {
    if (alertDiv.parentNode) {
      alertDiv.remove();
    }
  }, 5000);
}

// Função para atualizar automaticamente a lista de trades
function refreshTradesList() {
  const tradesTable = document.querySelector('#trades-table tbody');
  if (!tradesTable) return;
  
  fetch('/trades', {
    headers: {
      'X-Requested-With': 'XMLHttpRequest',
      'Accept': 'application/json'
    }
  })
  .then(response => response.json())
  .then(data => {
    if (data.trades) {
      updateTradesTable(data.trades);
    }
  })
  .catch(error => {
    console.error('Erro ao atualizar lista de trades:', error);
  });
}

function updateTradesTable(trades) {
  const tbody = document.querySelector('#trades-table tbody');
  if (!tbody) return;
  
  tbody.innerHTML = '';
  
  trades.forEach(trade => {
    const row = document.createElement('tr');
    row.innerHTML = `
      <td>#${trade.id}</td>
      <td>${trade.cryptocurrency_name}</td>
      <td>
        <span class="badge bg-${trade.operation_type === 'buy' ? 'success' : 'danger'}">
          ${trade.operation_type === 'buy' ? 'Compra' : 'Venda'}
        </span>
      </td>
      <td>${parseFloat(trade.quantity).toFixed(8)}</td>
      <td>$${parseFloat(trade.price).toFixed(2)}</td>
      <td>$${(parseFloat(trade.quantity) * parseFloat(trade.price)).toFixed(2)}</td>
      <td>
        <span class="badge bg-${trade.status === 'open' ? 'warning' : 'success'}">
          ${trade.status === 'open' ? 'Aberta' : 'Pareada'}
        </span>
      </td>
      <td>${new Date(trade.created_at).toLocaleDateString('pt-BR')}</td>
      <td>
        <a href="/trades/${trade.id}" class="btn btn-sm btn-outline-primary">Ver</a>
        ${trade.status === 'open' ? `
          <a href="/trades/${trade.id}" class="btn btn-sm btn-outline-danger" 
             data-method="delete" data-confirm="Tem certeza?">Excluir</a>
        ` : ''}
      </td>
    `;
    tbody.appendChild(row);
  });
}