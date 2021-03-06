<template>
  <form>
    <div class="form-group row">
      <label class="col-sm-5 col-form-label">URL</label>
      <input class="form-control col-sm-7" v-model="baseURL" type="text" readonly>
    </div>
    <div class="form-group row">
      <label class="col-sm-9 col-form-label">Version</label>
      <input class="form-control col-sm-3" v-model="version" type="text" readonly>
    </div>
    <div class="form-group row">
      <label class="col-sm-9 col-form-label">API Version</label>
      <select class="form-control col-sm-3" v-model="apiVersion" v-on:change="toggleMarketSelection(); loadVINs(); emitVersionChange()">
        <option>v2</option>
        <option>v3</option>
      </select>
    </div>
    <div class="form-group row">
      <label class="col-sm-9 col-form-label">Market</label>
      <select class="form-control col-sm-3" v-model="market" :disabled="isMarketSelectable != 1" v-on:change="loadVINs(); emitMarketChange()">
        <option v-for="m in markets" v-bind:key="m">
          {{ m.label }}
        </option>
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
      version: "",
      selectedVin: "",
      vins: [],
      selectedModel: "",
      models: [],
      markets: [],
      market: "v",
      isMarketSelectable: false,
      apiVersion: "v2"
    };
  },
  created() {
    fetchVINs(this.baseURL, this.apiVersion, this.market).then(json => {
      this.vins = json;
    });
    fetchMarkets(this.baseURL).then(json => {
      this.markets = json.markets;
    });
    fetchVersion(this.baseURL).then(json => {
      this.version = json['reach api version']
    });
  },
  methods: {
    toggleMarketSelection: function() {
      this.isMarketSelectable = this.apiVersion == "v3";
    },
    loadVINs: function() {
      fetchVINs(this.baseURL, this.apiVersion, this.market).then(json => {
        this.vins = json;
      });
    },
    loadModels: function() {
      let m = this.selectedVin.trim().split(" ");
      let vinClass = m[m.length - 2].trim();
      let vinYear = m[m.length - 1].trim();
      fetchModels(this.baseURL, this.apiVersion, this.market, vinClass, vinYear).then(json => {
        this.models = json.models;
      });
      this.$root.$emit("models_change", this.market);
    },
    loadSubstances: function() {
      let m = this.selectedModel.trim().split(" ");
      let base = m[m.length - 2].trim();
      let year = m[m.length - 1].trim();
      this.$root.$emit("model_change", base, year);
    },
    emitVersionChange: function() {
      this.selectedVin = ''
      this.selectedModel = ''
      this.$root.$emit("version_change", this.apiVersion);
    },
    emitMarketChange: function() {
      this.selectedVin = ''
      this.selectedModel = ''
      this.$root.$emit("market_change", this.market);
    }
  }
};

async function fetchVersion(url) {
  let response = await fetch(`https://${url}/api/about`)
  let data = await response.json();
  return data;
}

async function fetchVINs(url, apiVersion, market) {
  let response = await fetch(vinsURL(url, apiVersion, market))
  let data = await response.json();
  return data;
}

function vinsURL(baseURL, version, market) {
  if (version == "v2") {
    return `https://${baseURL}/api/${version}/models`
  } else {
    return `https://${baseURL}/api/${version}/models/${market}`
  }
}

async function fetchModels(url, apiVersion, market, vinClass, vinYear) {
  let response = await fetch(modelsURL(url, apiVersion, market, vinClass, vinYear))
  let data = await response.json();
  return data;
}

async function fetchMarkets(url) {
  let response = await fetch(`https://${url}/api/v3/markets`)
  let data = await response.json();
  return data;
}

function modelsURL(baseURL, version, market, vinClass, vinYear) {
  if (version == "v2") {
    return `https://${baseURL}/api/${version}/models/${vinClass}/${vinYear}`
  } else {
    return `https://${baseURL}/api/${version}/models/${market}/${vinClass}/${vinYear}`
  }
}
</script>