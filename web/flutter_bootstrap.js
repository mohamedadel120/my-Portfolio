{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load({
  onEntrypointLoaded: async function(engineInitializer) {
    const appRunner = await engineInitializer.initializeEngine();
    
    // Hide the loader container smoothly
    const loader = document.querySelector('.loader-container');
    if (loader) {
      loader.style.transition = 'opacity 0.5s ease-out';
      loader.style.opacity = '0';
      setTimeout(() => loader.remove(), 500);
    }
    
    await appRunner.runApp();
  }
});
