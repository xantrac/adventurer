import "phoenix_html";
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";
import { mount } from "./mounter";
import { deserialise } from "kitsu-core";

let Hooks = {};

Hooks.NodesBuilder = {
  mounted() {
    this.unmountComponent = mount(this.el.id, this.opts());
    this.handleEvent("react.update_story", ({ story }) => {
      mount(this.el.id, { story: deserialise(story) });
    });
  },

  showNodeEditor(item) {
    this.pushEventTo(this.el, "ui.start_edit", { item });
  },

  destroyed() {
    if (!this.unmountComponent) {
      return;
    }

    this.unmountComponent(this.el);
  },

  opts() {
    return {};
  },
};

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  hooks: Hooks,
  params: { _csrf_token: csrfToken },
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
