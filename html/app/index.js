const { createApp } = Vue;
import radar from "./pages/radar/index.js";
import tablet from "./pages/tablet/index.js";

const store = Vuex.createStore({
    state: {
        isRadarActive: false,
        isTabletActive: false,
        radarData: false,
        selectedLanguage: "",
        Locales: {},
    },
    mutations: {
        setIsRadarActive(state, payload) {
            state.isRadarActive = payload;
        },
        setSelectedLanguage(state, payload) {
            state.selectedLanguage = payload
            localStorage.setItem("selectedLanguage", JSON.stringify(payload));
        },
        setSelectedLanguageFirstMount(state, payload) {
            state.selectedLanguage = payload
        },
        setLocales(state, payload) {
            state.Locales = payload
        },
        setIsTabletActive(state, payload) {
            state.isTabletActive = payload;
        },
        getRadarData(state, payload) {
            state.radarData = payload;
        },
        getProfile(state, payload) {
            state.profile = payload;
        }
    },
    actions: {}
});

const app = createApp({
    data() {
        return {};
    },
    methods: {
        ...Vuex.mapMutations({
            setIsRadarActive: "setIsRadarActive",
            setIsTabletActive: "setIsTabletActive",
            getRadarData: "getRadarData",
            getProfile: "getProfile",
            setLocales : "setLocales",
            setSelectedLanguageFirstMount : 'setSelectedLanguageFirstMount',
            setSelectedLanguage : 'setSelectedLanguage',
        }),
        messageHandler(event) {
            switch (event.data.action) {
                case "TOGGLE_RADAR":
                    this.setIsRadarActive(event.data.payload);
                    break;
                case "TOGGLE_TABLET":
                    this.setIsTabletActive(event.data.payload);
                    break;
                case "GET_RADAR_DATA":
                    this.getRadarData(event.data.payload);
                    break;
                case "GET_PROFILE":
                    this.getProfile(event.data.payload);
                    break;
                case "PLAY_SOUND":
                    let audio = new Audio(`./assets/${event.data.payload}.ogg`);
                    audio.play();
                    audio.volume = 0.2;
                    break
                case "GET_LANGUAGE_VALUE":
                    const eventPayload = JSON.parse(event.data.payload)
                    if (this.selectedLanguage === "default") {
                        this.setLocales(eventPayload.DefaultLocales)
                    } else if (this.selectedLanguage === "en") {
                        this.setLocales(eventPayload.EnglishLocales)

                    } else if (this.selectedLanguage === "tr") {
                        this.setLocales(eventPayload.TurkishLocales)
                    } else if (this.selectedLanguage === "de") {
                        this.setLocales(eventPayload.DeutschLocales)
                    } else if (this.selectedLanguage === "es") {
                        this.setLocales(eventPayload.EspanolLocales)
                    } else if (this.selectedLanguage === "pr") {
                        this.setLocales(eventPayload.PortugalLocales)
                    } else if (this.selectedLanguage === "in") {
                        this.setLocales(eventPayload.HindiLocales)
                    }

                    break
                default:
                    break;
            }
        }
    },
    components: { radar, tablet },
    computed: {
        ...Vuex.mapState({
            isRadarActive: state => state.isRadarActive,
            isTabletActive: state => state.isTabletActive,
            radarData: state => state.radarData,
            profile: state => state.profile,
            selectedLanguage : state => state.selectedLanguage,
        })
    },
    mounted() {
        window.addEventListener("message", this.messageHandler);
        let stored = JSON.parse(localStorage.getItem("selectedLanguage"));
        if (stored != null || stored != undefined) {
    
            this.setSelectedLanguageFirstMount(stored)
        }else{
            this.setSelectedLanguage("default")
        }
    },
    beforeDestroy() {
        window.removeEventListener("message", this.messageHandler);
    },
    watch:{
        selectedLanguage(val){


            postNUI("selectLanguage", {
                language : val
            })
        }
    },
});
app.use(store);
app.mount("#app");

var resourceName = "xRadar";

if (window.GetParentResourceName) {
    resourceName = window.GetParentResourceName();
}


window.postNUI = async (name, data) => {
    try {
        const response = await fetch(`https://${resourceName}/${name}`, {
            method: "POST",
            mode: "cors",
            cache: "no-cache",
            credentials: "same-origin",
            headers: {
                "Content-Type": "application/json"
            },
            redirect: "follow",
            referrerPolicy: "no-referrer",
            body: JSON.stringify(data)
        });
        return !response.ok ? null : response.json();
    } catch (error) {
        // console.log(error)
    }
};
