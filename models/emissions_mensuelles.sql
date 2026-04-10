with voyages as (

    select * from {{ ref('voyages') }}

),

ref_fe as (

    select
        KPI_FE,
        Conversion_donnee_activite,
        Valeur_FE
    from {{ ref('ref_fe') }}

),

voyages_normalises as (

    select
        Invoice_Month,
        Primary_Product_Code,
        OD_Mileage,
        case
            when Primary_Product_Code = 'Air' then 'Avion'
            when Primary_Product_Code = 'Rail' then 'Train'
        end as KPI_FE
    from voyages
    where Primary_Product_Code in ('Air', 'Rail')

)

select
    Invoice_Month,
    Primary_Product_Code,
    round(sum(OD_Mileage * Conversion_donnee_activite * Valeur_FE), 2) as total_carbon_emissions
from voyages_normalises v
join ref_fe r
    on v.KPI_FE = r.KPI_FE
group by 1, 2
order by 1, 2