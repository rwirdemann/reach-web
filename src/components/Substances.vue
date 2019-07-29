<template>
  <div>
    <table class="table">
      <thead>
        <tr>
          <th scope="col">Part</th>
          <th scope="col">Substance</th>
          <th scope="col">CAS</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="s in substances" v-bind:key="s.NameDE">
          <td>{{ s.TeivonDE }}</td>
          <td>{{ s.NameDE }}</td>
          <td>{{ s.CAS }}</td>
        </tr>
      </tbody>
    </table>
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
    this.$root.$on("models_change", (base, year) => {
      this.substances = []
    });
    this.$root.$on("model_change", (base, year) => {
      fetchSubstances(this.baseURL, this.apiVersion, this.market, base, year).then(json => {
        this.substances = json.vehicle.reach;
      });
    });
    this.$root.$on("version_change", (version) => {
      this.apiVersion = version
      this.substances = []
    });
    this.$root.$on("market_change", (market) => {
      this.market = market
      this.substances = []
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