import importTemplate from "../../utils/importTemplate.js";
import inlinesvg from "../../utils/inlinesvg.js";
import settings from "./components/settings/index.js";
import radardata from "./components/radardata/index.js";

export default {
    data() {
        return {
            logo: "./assets/logo.png",
            showSelect: false,
            activePage: "",
            boloPlate: "",
            frontScannedVehicles: 0,
            rearScannedVehicles: 0,
            radarTime: 0,

     
        };
    },
    components: {
        inlinesvg,
        settings,
        radardata
    },
    computed: {
        getProfile() {
            return this.$store.state.profile;
        },
        toHHMMSS() {
            var sec_num = parseInt(this.radarTime, 10); // don't forget the second param
            var hours = Math.floor(sec_num / 3600);
            var minutes = Math.floor((sec_num - (hours * 3600)) / 60);
            var seconds = sec_num - (hours * 3600) - (minutes * 60);

            if (hours < 10) { hours = "0" + hours; }
            if (minutes < 10) { minutes = "0" + minutes; }
            if (seconds < 10) { seconds = "0" + seconds; }
            return minutes + ' Minute ' + seconds + ' Second';
        },
        ...Vuex.mapState({
            selectedLanguage: state => state.selectedLanguage,
            Locales : state => state.Locales,
        })

    },


    methods: {
        ...Vuex.mapMutations({
            setIsTabletActive: "setIsTabletActive",
            setSelectedLanguage : 'setSelectedLanguage',
        }),

        PlaySound() {
            let audio = new Audio(`./assets/btn.ogg`);
            audio.play();
            audio.volume = 0.2;
        },
        setShowSelect(payload) {
            this.showSelect = payload;
        },
        addBoloPlate() {
            postNUI("addBoloPlate", {
                plate: this.boloPlate
            });
            this.boloPlate = "";
        },
        FormatNum(speed) {
            if (!isNaN(speed)) {
                speed = speed.toString()
            }
            if (speed.length == 1) {
                if (speed == 10) {
                }
                return `00<span>${speed[0]}</span>`;
            }
            if (speed.length == 2) {
                if (speed == 10) {
                }
                return `0<span>${speed[0]}</span><span>${speed[1]}</span>`;
            }
            if (speed.length == 3) {
                if (speed == 10) {
                }
                return `<span>${speed[0]}</span><span>${speed[1]}</span><span>${speed[2]}</span>`;
            }

            return "000";
        },
        clearBoloPlate() {
            postNUI("clearBoloPlate", {
                plate: this.boloPlate
            });
            this.boloPlate = "";
        },
        messageHandler(event) {
            switch (event.data.action) {
                case "SET_REAR_SCANNED_VEHICLES":
                    this.rearScannedVehicles = event.data.payload
                    break
                case "SET_FRONT_SCANNED_VEHICLES":
                    this.frontScannedVehicles = event.data.payload
                    break
                case "UPDATE_RADAR_TIME":
                    this.radarTime = event.data.payload
                    break
        
                default:
                    break;
            }
        },
        setActivePage(payload) {
            this.activePage = payload;
        },
        keyHandler(e) {
            if (e.which == 27) {
                postNUI('closeTablet')
                this.setIsTabletActive(false)
            }
        },
    },
    mounted() {
        window.addEventListener("message", this.messageHandler);
        window.addEventListener("keyup", this.keyHandler);
    },
    beforeDestroy() {
        window.removeEventListener("message", this.messageHandler);
        window.removeEventListener("keyup", this.keyHandler);

    },
    template: await importTemplate("./app/pages/tablet/index.html")
};
