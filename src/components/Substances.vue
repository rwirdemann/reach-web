<template>
  <div>
    <ul class="list-group">
      <li class="list-group-item" v-for="s in substances" v-bind:key="s.NameDE">{{ s.NameDE }}</li>
    </ul>
  </div>
</template>

<script>
export default {
  name: "Substances",
  props: {
    baseURL: String
  },
  data() {
    return {
      substances: [],
      apiVersion: "v2",
      market: "v"
    };
  },
  created() {},
  mounted() {
    this.$root.$on("model_change", (base, year) => {
      fetchSubstances(this.baseURL, this.apiVersion, this.market, base, year).then(json => {
        this.substances = json.vehicle.reach;
      });
    });
    this.$root.$on("version_change", (version) => {
      this.apiVersion = version
    });
    this.$root.$on("market_change", (market) => {
      this.market = market
    });
  }
};

async function fetchSubstances(url, version, market, base, year) {
  let response = await fetch(substancesURL(url, version, market, base, year));
  let data = await response.json();
  return data;
}

function substancesURL(baseURL, version, market, base, year) {
  if (version == "v2") {
    return `https://${baseURL}/api/${version}/substances/${base}/${year}`
  } else {
    return `https://${baseURL}/api/${version}/substances/${market}/${base}/${year}`
  }
}
</script>