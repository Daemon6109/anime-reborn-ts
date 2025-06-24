import { PassiveData } from "../passive";

export const FrostDemon: PassiveData = {
    name: "Frost Demon",
    description: "Applies 'Frost Bite' effect on all attacks.",
    callbacks: {}, // Logic for applying status effect likely handled by attack/status system via a tag or property.
                   // e.g., unit could have a tag "AppliesFrostBite"
};
