<template>
  <div id="app">
    <div class="row">
      <div class="col-4">
        <Panel baseURL="reach-dev.skunkworksngwsa.de" />
      </div>
      <div class="col-8">
        <Substances baseURL="reach-dev.skunkworksngwsa.de" />
      </div>
    </div>
  </div>
</template>

<script>
import Panel from "./components/Panel.vue";
import Substances from "./components/Substances.vue";

export default {
  name: "app",
  components: {
    Panel, Substances
  }
};
</script>