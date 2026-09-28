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
    participant_name_client: 100
  };

  // Estado de priorización totalmente local al navegador.
  // Los clics + / - NO generan eventos Shiny ni consultas al servidor.
  var voteState = {};
  var voteActivityByConclusion = {};
  var localVoteBusy = false;
  var savedVoteActivities = {};

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
    ['persona_registro', 'participant_name_client'].forEach(function (id) {
      var el = document.getElementById(id);
      if (el && !el.value) {
        el.value = saved;
        el.dispatchEvent(new Event('input', { bubbles: true }));
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

  function el(tag, className, text) {
    var node = document.createElement(tag);
    if (className) node.className = className;
    if (typeof text !== 'undefined' && text !== null) node.textContent = text;
    return node;
  }

  function votingSections() {
    return Array.from(document.querySelectorAll('.activity-vote-section[data-activity-id]'));
  }

  function applyActivityFilter() {
    var filter = document.getElementById('priority_activity_filter_client');
    var selected = filter ? String(filter.value || '') : '';
    votingSections().forEach(function (section) {
      var aid = String(section.dataset.activityId || '');
      section.style.display = (selected && selected === aid) ? '' : 'none';
    });
    updateVotingUI();
  }

  function ensureVotingStateFromDOM() {
    document.querySelectorAll('[data-vote-local="true"]').forEach(function (btn) {
      var id = String(btn.dataset.id || '');
      var aid = String(btn.dataset.activityId || '');
      if (!id || !aid) return;
      if (typeof voteState[id] === 'undefined') voteState[id] = 0;
      voteActivityByConclusion[id] = aid;
    });
  }

  function activityTotal(activityId) {
    var total = 0;
    Object.keys(voteState).forEach(function (id) {
      if (String(voteActivityByConclusion[id]) === String(activityId)) {
        total += Number(voteState[id] || 0);
      }
    });
    return total;
  }

  function updateVotingUI() {
    ensureVotingStateFromDOM();

    var filter = document.getElementById('priority_activity_filter_client');
    var selected = filter ? String(filter.value || '') : '';
    var selectedSection = null;

    votingSections().forEach(function (section) {
      var aid = String(section.dataset.activityId || '');
      var limit = Number(section.dataset.pointsLimit || 5);
      var total = activityTotal(aid);
      var remaining = Math.max(0, limit - total);

      if (selected && aid === selected) selectedSection = section;

      var counter = document.querySelector('[data-activity-counter="' + aid + '"]');
      if (counter) {
        counter.classList.toggle('complete', total === limit);
        var big = counter.querySelector('.points-big');
        var label = counter.querySelector('.points-label');
        var small = counter.querySelector('.points-small');
        if (big) big.textContent = String(remaining);
        if (label) label.textContent = remaining === 1 ? 'punto restante' : 'puntos restantes';
        if (small) small.textContent = total + ' de ' + limit + ' asignados';
      }

      section.querySelectorAll('[data-vote-local="true"]').forEach(function (btn) {
        var id = String(btn.dataset.id || '');
        var delta = Number(btn.dataset.delta || 0);
        var value = Number(voteState[id] || 0);
        if (delta > 0) btn.disabled = localVoteBusy || total >= limit;
        if (delta < 0) btn.disabled = localVoteBusy || value <= 0;
      });
    });

    document.querySelectorAll('[data-vote-number]').forEach(function (node) {
      node.textContent = String(voteState[node.dataset.voteNumber] || 0);
    });

    var nameInput = document.getElementById('participant_name_client');
    var nameOk = !!(nameInput && (nameInput.value || '').trim());
    var submit = document.getElementById('submit_votes_client');
    var status = document.getElementById('voting_client_status');

    if (!selected || !selectedSection) {
      if (submit) {
        submit.disabled = true;
        if (!localVoteBusy) submit.textContent = 'Seleccione una actividad';
      }
      if (status) {
        status.textContent = 'Seleccione una actividad para asignar y enviar sus 5 puntos.';
        status.classList.remove('complete');
      }
      return;
    }

    var activityName = String(selectedSection.dataset.activityName || 'Actividad');
    var limit = Number(selectedSection.dataset.pointsLimit || 5);
    var hasConclusions = String(selectedSection.dataset.hasConclusions || 'false') === 'true';
    var total = activityTotal(selected);
    var complete = hasConclusions && total === limit;

    var alreadySaved = !!savedVoteActivities[selected];
    if (submit) {
      submit.disabled = localVoteBusy || !complete || !nameOk;
      if (!localVoteBusy) {
        submit.textContent = (alreadySaved ? 'Reenviar priorización de ' : 'Enviar priorización de ') + activityName;
      }
    }

    if (status) {
      if (!hasConclusions) {
        status.textContent = 'No hay conclusiones habilitadas para ' + activityName + '.';
      } else if (complete && nameOk && alreadySaved) {
        status.textContent = activityName + ': priorización enviada. Puede pasar a otra actividad o modificar y reenviar estos 5 puntos.';
      } else if (complete && nameOk) {
        status.textContent = activityName + ': 5/5 puntos. Ya puede enviar esta actividad.';
      } else {
        status.textContent = activityName + ': ' + total + '/' + limit + ' puntos asignados.';
      }
      status.classList.toggle('complete', complete && nameOk);
    }
  }

  function submitClientVote() {
    if (localVoteBusy) return;
    var submit = document.getElementById('submit_votes_client');
    if (!submit || submit.disabled) return;

    var nameInput = document.getElementById('participant_name_client');
    var participant = nameInput ? (nameInput.value || '').trim() : '';
    if (!participant) return;

    var filter = document.getElementById('priority_activity_filter_client');
    var activityId = filter ? String(filter.value || '') : '';
    if (!activityId) return;

    var votes = Object.keys(voteState)
      .filter(function (id) {
        return String(voteActivityByConclusion[id] || '') === activityId && Number(voteState[id] || 0) > 0;
      })
      .map(function (id) { return { id: id, puntos: Number(voteState[id]) }; });

    localVoteBusy = true;
    submit.textContent = 'Guardando priorización…';
    updateVotingUI();

    if (window.Shiny) {
      Shiny.setInputValue('vote_submit_client', {
        participant: participant,
        activity_id: activityId,
        votes: votes,
        nonce: Date.now() + Math.random()
      }, { priority: 'event' });
    }
  }

  document.addEventListener('change', function (event) {
    if (event.target && event.target.id === 'priority_activity_filter_client') {
      applyActivityFilter();
      return;
    }
  });

  document.addEventListener('click', function (event) {
    var categoryButton = event.target.closest('.category-btn');
    if (categoryButton) {
      event.preventDefault();
      document.querySelectorAll('.category-btn').forEach(function (node) {
        node.classList.remove('selected');
        node.setAttribute('aria-pressed', 'false');
      });
      categoryButton.classList.add('selected');
      categoryButton.setAttribute('aria-pressed', 'true');
      if (window.Shiny) {
        Shiny.setInputValue('selected_categories', [categoryButton.dataset.category], { priority: 'event' });
      }
      return;
    }

    var localVoteButton = event.target.closest('[data-vote-local="true"]');
    if (localVoteButton) {
      event.preventDefault();
      if (localVoteBusy) return;

      ensureVotingStateFromDOM();

      var id = String(localVoteButton.dataset.id || '');
      var aid = String(localVoteButton.dataset.activityId || voteActivityByConclusion[id] || '');
      var delta = Number(localVoteButton.dataset.delta || 0);
      var section = localVoteButton.closest('.activity-vote-section');
      var limit = Number(section && section.dataset.pointsLimit ? section.dataset.pointsLimit : 5);
      var current = Number(voteState[id] || 0);
      var total = activityTotal(aid);

      if (delta > 0 && total >= limit) return;
      if (delta < 0 && current <= 0) return;

      voteState[id] = Math.max(0, current + delta);
      savedVoteActivities[aid] = false;
      updateVotingUI();
      return;
    }

    var submitButton = event.target.closest('#submit_votes_client');
    if (submitButton) {
      event.preventDefault();
      submitClientVote();
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

  document.addEventListener('input', function (event) {
    applyLimitToElement(event.target);
    if (event.target && event.target.id === 'participant_name_client') {
      if (window.localStorage) {
        var value = (event.target.value || '').trim();
        if (value) localStorage.setItem(NAME_KEY, value);
      }
      updateVotingUI();
    }
  });

  document.addEventListener('focusin', function (event) {
    applyLimitToElement(event.target);
    if (event.target && event.target.id === 'municipios-selectized') {
      event.target.setAttribute('maxlength', '100');
    }
  });

  document.addEventListener('change', function (event) {
    if ((event.target.id === 'persona_registro' || event.target.id === 'participant_name_client') && window.localStorage) {
      var value = (event.target.value || '').trim();
      if (value) localStorage.setItem(NAME_KEY, value);
    }
    if (event.target.id === 'comision_registro' && window.localStorage) {
      var groupValue = (event.target.value || '').trim();
      if (groupValue) localStorage.setItem(GROUP_KEY, groupValue);
    }
  });

  function registerHandlers() {
    if (handlersRegistered || !window.Shiny) return false;
    handlersRegistered = true;

    Shiny.addCustomMessageHandler('resetCategories', function () {
      document.querySelectorAll('.category-btn.selected').forEach(function (node) {
        node.classList.remove('selected');
        node.setAttribute('aria-pressed', 'false');
      });
      Shiny.setInputValue('selected_categories', [], { priority: 'event' });
    });

    Shiny.addCustomMessageHandler('rememberContributor', function (message) {
      if (window.localStorage && message && message.name) localStorage.setItem(NAME_KEY, message.name);
      applyRememberedName();
      applyRememberedGroup();
    });

    Shiny.addCustomMessageHandler('voteBusy', function (message) {
      localVoteBusy = !!(message && message.busy);
      var submit = document.getElementById('submit_votes_client');
      if (submit && localVoteBusy) submit.textContent = 'Guardando priorización…';
      updateVotingUI();
    });

    Shiny.addCustomMessageHandler('voteActivitySaved', function (message) {
      var aid = String(message && message.activity_id ? message.activity_id : '');
      if (aid) savedVoteActivities[aid] = true;
      localVoteBusy = false;
      updateVotingUI();
    });

    Shiny.addCustomMessageHandler('resetVotingActivity', function (message) {
      ensureVotingStateFromDOM();
      var aid = String(message && message.activity_id ? message.activity_id : '');
      Object.keys(voteState).forEach(function (id) {
        if (String(voteActivityByConclusion[id] || '') === aid) voteState[id] = 0;
      });
      localVoteBusy = false;
      updateVotingUI();
    });

    // Compatibilidad con mensajes de versiones anteriores.
    Shiny.addCustomMessageHandler('resetVotingClient', function () {
      ensureVotingStateFromDOM();
      Object.keys(voteState).forEach(function (id) { voteState[id] = 0; });
      localVoteBusy = false;
      updateVotingUI();
    });

    setTimeout(function () {
      applyRememberedName();
      applyRememberedGroup();
      applyStaticLimits();
      applyActivityFilter();
      updateVotingUI();
    }, 250);

    return true;
  }

  if (window.jQuery) {
    jQuery(document).on('shiny:value', function (event) {
      if (event && event.name === 'prioritization_cards_ui') {
        setTimeout(function () {
          voteState = {};
          voteActivityByConclusion = {};
          savedVoteActivities = {};
          localVoteBusy = false;
          applyRememberedName();
          applyActivityFilter();
          updateVotingUI();
        }, 0);
      }
    });
  }

  document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.category-btn').forEach(function (node) {
      node.setAttribute('aria-pressed', 'false');
    });
    applyStaticLimits();
    applyActivityFilter();
  });

  // Shiny dispara shiny:connected como evento jQuery en algunos clientes y
  // versiones. Además hacemos polling breve para que el registro sea robusto
  // aunque app.js se cargue antes que Shiny.
  if (window.Shiny) {
    registerHandlers();
  } else {
    if (window.jQuery) {
      jQuery(document).one('shiny:connected', function () { registerHandlers(); });
    }
    document.addEventListener('shiny:connected', function () { registerHandlers(); }, { once: true });

    var shinyWaitCount = 0;
    var shinyWait = setInterval(function () {
      shinyWaitCount += 1;
      if (registerHandlers() || shinyWaitCount >= 200) {
        clearInterval(shinyWait);
      }
    }, 100);
  }
})();
