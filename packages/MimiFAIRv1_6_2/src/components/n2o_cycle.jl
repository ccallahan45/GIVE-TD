# --------------------------------------------------
# Nitrous Oxide Cycle.
# --------------------------------------------------

@defcomp n2o_cycle begin

    emiss2conc_n2o     = Parameter()             # Conversion between ppb/ppt concentrations and Mt/kt emissions.
    N₂O_0              = Parameter()             # Initial nitrous oxide concentration in first model period (ppb).
    τ_N₂O              = Parameter()             # Atmospheric (e-folding) lifetime of N₂O (dfault = 121 years).
    fossil_emiss_N₂O   = Parameter(index=[time]) # Fossil-fuel nitrous oxide emissions (Mt N₂ yr⁻¹).
    natural_emiss_N₂O  = Parameter(index=[time]) # Natural nitrous oxide emissions (Mt N₂ yr⁻¹).

    N₂O                = Variable(index=[time])  # Atmospheric nitrous oxide concentration (ppb).


    function run_timestep(p, v, d, t)

        # Set initial nitrous oxide concentration value.
        if is_first(t)
            v.N₂O[t] = p.N₂O_0
        else
            # Calculate atmospheric nitrous oxide concentration.
            # Note: natural emissions always for period 't' in FAIR code.
            emiss_prev = p.fossil_emiss_N₂O[t-1] + p.natural_emiss_N₂O[t]
            emiss_curr = p.fossil_emiss_N₂O[t] + p.natural_emiss_N₂O[t]
            v.N₂O[t] = v.N₂O[t-1] - v.N₂O[t-1] * (1.0 - exp(-1/p.τ_N₂O)) + 0.5 * (emiss_prev + emiss_curr) * (1.0/p.emiss2conc_n2o)
        end
    end
end
