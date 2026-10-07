(() => {
  const root = document.documentElement;
  const motionQuery = window.matchMedia('(prefers-reduced-motion: reduce)');
  const motionButton = document.querySelector('#motion');
  let motionOff = motionQuery.matches;

  const setMotion = (off) => {
    motionOff = off;
    root.classList.toggle('no-motion', off);
    if (motionButton) {
      motionButton.setAttribute('aria-pressed', String(off));
      motionButton.textContent = off ? 'Motion: off' : 'Motion: on';
    }
  };

  setMotion(motionOff);
  motionButton?.addEventListener('click', () => setMotion(!motionOff));
  motionQuery.addEventListener('change', (event) => setMotion(event.matches));

  const reveals = [...document.querySelectorAll('.reveal')];
  if ('IntersectionObserver' in window && !motionOff) {
    const observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('is-visible');
          observer.unobserve(entry.target);
        }
      });
    }, { threshold: 0.12 });
    reveals.forEach((element) => observer.observe(element));
  } else {
    reveals.forEach((element) => element.classList.add('is-visible'));
  }

  const tabs = [...document.querySelectorAll('[role="tab"]')];
  const chooseTab = (selected, focus = false) => {
    tabs.forEach((tab) => {
      const active = tab === selected;
      tab.setAttribute('aria-selected', String(active));
      tab.tabIndex = active ? 0 : -1;
      const panel = document.getElementById(tab.getAttribute('aria-controls'));
      if (panel) panel.hidden = !active;
    });
    if (focus) selected.focus();
  };

  tabs.forEach((tab, index) => {
    tab.addEventListener('click', () => chooseTab(tab));
    tab.addEventListener('keydown', (event) => {
      let next;
      if (event.key === 'ArrowRight') next = (index + 1) % tabs.length;
      if (event.key === 'ArrowLeft') next = (index + tabs.length - 1) % tabs.length;
      if (event.key === 'Home') next = 0;
      if (event.key === 'End') next = tabs.length - 1;
      if (next !== undefined) {
        event.preventDefault();
        chooseTab(tabs[next], true);
      }
    });
  });

  const jobs = [...document.querySelectorAll('.job')];
  const expandButton = document.querySelector('#expand-all');
  const updateExpandButton = () => {
    if (!expandButton) return;
    const allOpen = jobs.every((job) => job.open);
    expandButton.textContent = allOpen ? 'Collapse all' : 'Expand all';
    expandButton.setAttribute('aria-expanded', String(allOpen));
  };

  expandButton?.addEventListener('click', () => {
    const shouldOpen = !jobs.every((job) => job.open);
    jobs.forEach((job) => { job.open = shouldOpen; });
    updateExpandButton();
  });
  jobs.forEach((job) => job.addEventListener('toggle', updateExpandButton));
  updateExpandButton();

  let printState = [];
  window.addEventListener('beforeprint', () => {
    printState = jobs.map((job) => job.open);
    jobs.forEach((job) => { job.open = true; });
  });
  window.addEventListener('afterprint', () => {
    jobs.forEach((job, index) => { job.open = printState[index]; });
    updateExpandButton();
  });
  document.querySelector('#print')?.addEventListener('click', () => window.print());

  const progress = document.querySelector('.progress');
  const updateProgress = () => {
    if (!progress) return;
    const available = document.documentElement.scrollHeight - window.innerHeight;
    progress.style.width = `${available > 0 ? (window.scrollY / available) * 100 : 0}%`;
  };
  window.addEventListener('scroll', updateProgress, { passive: true });
  window.addEventListener('resize', updateProgress);
  updateProgress();
})();
