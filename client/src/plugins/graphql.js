
import Vue from 'vue';
import VueGraphQL from 'vue-graphql';
 
Vue.use(VueGraphQL);
 
const graphqlApi = 'https://your-api-endpoint.com/graphql'
const auth = 'REPLACE_WITH_YOUR_AUTH_TOKEN';
 
const client = new VueGraphQL.Client(graphqlApi, {
  headers: {
    Authorization: `Bearer ${auth}`,
  }
});
 
export default client;