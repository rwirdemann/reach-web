<template>
  <form>
    <div class="form-group row">
      <label class="col-sm-9 col-form-label">API Version</label>
      <select class="form-control col-sm-3" v-model="apiVersion" v-on:change="toggleMarketSelection(); loadVINs()">
        <option>v2</option>
        <option>v3</option>
      </select>
    </div>
    <div class="form-group row">
      <label class="col-sm-9 col-form-label">Market</label>
      <select class="form-control col-sm-3" v-model="market" :disabled="isMarketSelectable != 1" v-on:change="loadVINs()">
        <option>v</option>
        <option>n</option>
      </select>
    </div>
    <div class="form-group row">
      <label class="col-sm-9 col-form-label">VIN Class and Year</label>
      <select class="form-control col-sm-3" v-model="selectedVin" v-on:change="loadModels()">
        <option v-for="vin in vins" v-bind:key="vin.vin_class + vin.vin_year">
          {{ vin.vin_class }}
          {{ vin.vin_year }}
        </option>
      </select>
    </div>
    <div class="form-group row">
      <label class="col-sm-5 col-form-label">Models</label>
      <select class="form-control col-sm-7" v-model="selectedModel" v-on:change="loadSubstances()">
        <option v-for="model in models" v-bind:key="model.base_model + model.model_year">
          {{ model.model_name }}
          {{ model.base_model }}
          {{ model.model_year }}
        </option>
      </select>
    </div>
  </form>
</template>

<script>
export default {
  name: "Panel",
  props: {
    baseURL: String
  },
  data() {
    return {
      selectedVin: "",
      vins: [],
      selectedModel: "",
      models: [],
      market: "v",
      isMarketSelectable: false,
      apiVersion: "v2"
    };
  },
  created() {
    fetchVINs(this.baseURL, this.apiVersion, this.market).then(json => {
      this.vins = json;
    });
  },
  methods: {
    toggleMarketSelection: function() {
      this.isMarketSelectable = this.apiVersion == "v3";
    },
    loadVINs: function() {
      fetchVINs(this.baseURL, this.apiVersion, this.market).then(json => {
        this.models = json.models;
      });
    },
    loadModels: function() {
      let m = this.selectedVin.trim().split(" ");
      let vinClass = m[m.length - 2].trim();
      let vinYear = m[m.length - 1].trim();
      fetchModels(this.baseURL, vinClass, vinYear).then(json => {
        this.models = json.models;
      });
    },
    loadSubstances: function() {
      let m = this.selectedModel.trim().split(" ");
      let base = m[m.length - 2].trim();
      let year = m[m.length - 1].trim();
      this.$root.$emit("model_change", base, year);
    }
  }
};

async function fetchVINs(url, apiVersion, market) {
  var response;
  if (apiVersion === "v2") {
    response = await fetch("https://" + url + "/api/" + apiVersion + "/models");
  } else {
    response = await fetch( "https://" + url + "/api/" + apiVersion + "/" + market + "/models" );
  }
  let data = await response.json();
  return data;
}

async function fetchModels(url, vinClass, vinYear) {
  let response = await fetch(
    "https://" + url + "/api/v2/models/" + vinClass + "/" + vinYear
  );
  let data = await response.json();
  return data;
}
</script>
