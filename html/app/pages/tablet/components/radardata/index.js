import importTemplate from "../../../../utils/importTemplate.js";
import inlinesvg from "../../../../utils/inlinesvg.js";

export default {
    data() {
        return {
            showSelect: false,
            addPunishModal: false,
            searchBarRadarData: "",
            addPunishment: { imageURL: "", playerName: "", plate: "", description: "", location: "" },

        };
    },
    components: {
        inlinesvg
    },
    computed: {
        radarData() {
            return this.$store.state.radarData;
        },

        filterByTerm() {
            if (this.searchBarRadarData.length > 0) {
                return this.radarData.filter(report => {
                    return (
                        report.citizenname.toLowerCase().includes(this.searchBarRadarData.toLowerCase()) ||
                        report.officername.toLowerCase().includes(this.searchBarRadarData.toLowerCase()) ||
                        report.plate.toLowerCase().includes(this.searchBarRadarData.toLowerCase()) ||
                        report.description.toLowerCase().includes(this.searchBarRadarData.toLowerCase())
                    );
                });
            } else {
                return this.radarData;
            }
        },
        ...Vuex.mapState({
            Locales : state => state.Locales,
        })
    },
    methods: {
        sort(val) {
            if (val == "z-a") {
                this.radarData.sort((a, b) => b.citizenname.localeCompare(a.citizenname));
            }
            if (val == "a-z") {
                this.radarData.sort((a, b) => a.citizenname.localeCompare(b.citizenname));
            }
        },
        PlaySound(){
            let audio = new Audio(`./assets/btn.ogg`);
            audio.play();
            audio.volume = 0.2;
        },
        setAddPunishModal(payload) {
            this.addPunishModal = payload;
        },
        setShowSelect(payload) {
            this.showSelect = payload;
        },
        savePunishButton() {
            if (this.addPunishment.playerName != "" && this.addPunishment.plate != "" && this.addPunishment.description != "") {
                checkImage(this.addPunishment.imageURL)
                    .then(isValid => {
                        console.log(isValid);
                        if (isValid) {
                            console.log("Image is valid");
                        } else {
                            this.addPunishment.imageURL = false;
                        }
                    })
                    .catch(err => {
                        console.log(err);
                    });
                this.addPunishModal = false;
                setTimeout(() => {
                    postNUI("addPunishment", this.addPunishment);
                    this.addPunishment = { imageURL: "", playerName: "", plate: "", description: "" };
                }, 1000);
            } else {
                console.log("Please fill in all fields");
            }
        },
  
    },

    props: ["setActivePage"],
    template: await importTemplate("./app/pages/tablet/components/radardata/index.html")
};

function checkImage(url) {
    return new Promise((resolve, reject) => {
        let image = new Image();
        image.onload = function () {
            if (this.width > 0) {
                resolve(true);
            } else {
                resolve(false);
            }
        };
        image.onerror = function () {
            resolve(false);
        };
        image.src = url;
    });
}
