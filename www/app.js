(function () {
  'use strict';

  var NAME_KEY = 'tallerObservacionesNombre';
  var GROUP_KEY = 'tallerObservacionesGrupo';
  var handlersRegistered = false;

  var TEXT_LIMITS = {
    persona_registro: 100,
    observacion: 50,
    implicacion: 100,
    modal_conclusion: 100,
    participant_name: 100
  };

  function applyLimitToElement(el) {
    if (!el || !el.id) return;
    var max = TEXT_LIMITS[el.id];
    if (!max) return;
    el.setAttribute('maxlength', String(max));
    if (Array.from(el.value || '').length > max) {
      el.value = Array.from(el.value).slice(0, max).join('');
      el.dispatchEvent(new Event('change', { bubbles: true }));
    }
  }

  function applyStaticLimits() {
    Object.keys(TEXT_LIMITS).forEach(function (id) {
      applyLimitToElement(document.getElementById(id));
    });
    var municipioInput = document.getElementById('municipios-selectized');
    if (municipioInput) municipioInput.setAttribute('maxlength', '100');
  }

  function selectedCategories() {
    return Array.from(document.querySelectorAll('.category-btn.selected'))
      .map(function (el) { return el.dataset.category; });
  }

  function applyRememberedName() {
    var saved = window.localStorage ? localStorage.getItem(NAME_KEY) : '';
    if (!saved) return;
    ['persona_registro', 'participant_name'].forEach(function (id) {
      var el = document.getElementById(id);
      if (el && !el.value) {
        el.value = saved;
        el.dispatchEvent(new Event('change', { bubbles: true }));
      }
    });
  }

  function applyRememberedGroup() {
    var saved = window.localStorage ? localStorage.getItem(GROUP_KEY) : '';
    if (!saved) return;
    var el = document.getElementById('comision_registro');
    if (!el) return;
    if (window.jQuery && jQuery(el)[0] && jQuery(el)[0].selectize) {
      var control = jQuery(el)[0].selectize;
      if (control.options[saved] && control.getValue() !== saved) {
        control.setValue(saved, true);
      }
    }
  }

  document.addEventListener('click', function (event) {
    var categoryButton = event.target.closest('.category-btn');
    if (categoryButton) {
      event.preventDefault();

      // Selección exclusiva: una observación solo puede tener una clasificación.
      document.querySelectorAll('.category-btn').forEach(function (el) {
        el.classList.remove('selected');
        el.setAttribute('aria-pressed', 'false');
      });

      categoryButton.classList.add('selected');
      categoryButton.setAttribute('aria-pressed', 'true');

      if (window.Shiny) {
        Shiny.setInputValue('selected_categories', [categoryButton.dataset.category], { priority: 'event' });
      }
      return;
    }

    var voteButton = event.target.closest('.vote-btn');
    if (voteButton) {
      event.preventDefault();
      if (window.Shiny) {
        Shiny.setInputValue('vote_change', {
          id: voteButton.dataset.id,
          delta: parseInt(voteButton.dataset.delta, 10),
          nonce: Date.now() + Math.random()
        }, { priority: 'event' });
      }
      return;
    }

    var conclusionButton = event.target.closest('.conclusion-action-btn');
    if (conclusionButton) {
      event.preventDefault();
      if (window.Shiny) {
        Shiny.setInputValue('conclusion_action', {
          mode: conclusionButton.dataset.mode || 'add',
          id: conclusionButton.dataset.id || '',
          key: conclusionButton.dataset.key || '',
          nonce: Date.now() + Math.random()
        }, { priority: 'event' });
      }
    }
  });

  // Limita longitud sin contadores ni MutationObserver.
  document.addEventListener('input', function (event) {
    applyLimitToElement(event.target);
  });
  document.addEventListener('focusin', function (event) {
    applyLimitToElement(event.target);
    if (event.target && event.target.id === 'municipios-selectized') {
      event.target.setAttribute('maxlength', '100');
    }
  });

  document.addEventListener('change', function (event) {
    if ((event.target.id === 'persona_registro' || event.target.id === 'participant_name') && window.localStorage) {
      var value = (event.target.value || '').trim();
      if (value) localStorage.setItem(NAME_KEY, value);
    }
    if (event.target.id === 'comision_registro' && window.localStorage) {
      var groupValue = (event.target.value || '').trim();
      if (groupValue) localStorage.setItem(GROUP_KEY, groupValue);
    }
  });

  function registerHandlers() {
    if (handlersRegistered || !window.Shiny) return;
    handlersRegistered = true;

    Shiny.addCustomMessageHandler('resetCategories', function () {
      document.querySelectorAll('.category-btn.selected').forEach(function (el) {
        el.classList.remove('selected');
        el.setAttribute('aria-pressed', 'false');
      });
      Shiny.setInputValue('selected_categories', [], { priority: 'event' });
    });

    Shiny.addCustomMessageHandler('rememberContributor', function (message) {
      if (window.localStorage && message && message.name) localStorage.setItem(NAME_KEY, message.name);
      applyRememberedName();
      applyRememberedGroup();
    });

    setTimeout(function () {
      applyRememberedName();
      applyRememberedGroup();
      applyStaticLimits();
    }, 250);
  }

  document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.category-btn').forEach(function (el) {
      el.setAttribute('aria-pressed', 'false');
    });
    applyStaticLimits();
  });

  if (window.Shiny) registerHandlers();
  else document.addEventListener('shiny:connected', registerHandlers, { once: true });
})();
