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
      substances: []
    };
  },
  created() {},
  mounted() {
    this.$root.$on("model_change", (base, year) => {
      fetchSubstances(this.baseURL, base, year).then(json => {
        this.substances = json.vehicle.reach;
      });
    });
  }
};

async function fetchSubstances(url, base, year) {
  let response = await fetch(
    "https://" + url + "/api/v2/substances/" + base + "/" + year
  );
  let data = await response.json();
  return data;
}
</script>